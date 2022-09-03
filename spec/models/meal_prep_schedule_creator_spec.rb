require 'rails_helper'

RSpec.describe MealPrepSchedule::Creator, type: :model do
  describe '#create_schedule!' do
    let(:meal_prep_schedule_params) { { name: 'スケジュール1'} }
    let(:initial_count_params) { { main_count: 4, side_count: 7 } }

    it '作り置きスケジュール作成と同時に、アイテムも作成されること' do
      schedule = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params, initial_count_params).schedule

      expect(schedule.name).to eq 'スケジュール1'
      expect(schedule.items.where(meal_type: :main).size).to eq 4
      expect(schedule.items.where(meal_type: :side).size).to eq 7
    end

    context '作り置きを引き継ぐ場合' do
      let!(:past_schedule) { create(:meal_prep_schedule) }
      let!(:past_item_main1) { create(:meal_prep_schedule_item, name: '引き継ぎメイン1', prepared: true, meal_type: :main, meal_prep_schedule_id: past_schedule.id) }
      let!(:past_item_main2) { create(:meal_prep_schedule_item, name: '引き継ぎメイン2', prepared: true, meal_type: :main, meal_prep_schedule_id: past_schedule.id) }
      let!(:past_item_side1) { create(:meal_prep_schedule_item, name: '引き継ぎサイド1', prepared: true, meal_type: :side, meal_prep_schedule_id: past_schedule.id) }
      let!(:past_item_side2) { create(:meal_prep_schedule_item, name: '引き継ぎサイド2', prepared: true, meal_type: :side, meal_prep_schedule_id: past_schedule.id) }
      let!(:past_item_side3) { create(:meal_prep_schedule_item, name: '引き継ぎ消費済サイド', prepared: true, meal_type: :side, remaining_rate: 0, meal_prep_schedule_id: past_schedule.id) }

      context '引き継ぎが2品でどちらも残量100%の場合' do
        it '2品分は作成済と判断され、初期作成の作り置きアイテムが2品分減ること' do
          schedule = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params, initial_count_params, past_schedule.id).schedule

          item_names = schedule.items.map(&:name)
          expect(item_names.include?('引き継ぎメイン1')).to eq true
          expect(item_names.include?('引き継ぎメイン2')).to eq true
          expect(item_names.include?('引き継ぎサイド1')).to eq true
          expect(item_names.include?('引き継ぎサイド2')).to eq true
          expect(item_names.include?('引き継ぎ消費済サイド')).to eq false
          expect(item_names.include?('主菜2')).to eq true
          expect(item_names.include?('主菜3')).to eq false
          expect(item_names.include?('副菜5')).to eq true
          expect(item_names.include?('副菜6')).to eq false
          expect(schedule.items.main.size).to eq 4
          expect(schedule.items.side.size).to eq 7
        end
      end

      context '引き継ぎが2品で片方が残量50%の場合' do
        before do
          past_item_main1.update(remaining_rate: 50)
          past_item_side1.update(remaining_rate: 50)
        end

        it '1品分だけ作成済と判断され、初期作成の作り置きアイテムが1品分減ること' do
          schedule = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params, initial_count_params, past_schedule.id).schedule

          item_names = schedule.items.map(&:name)
          expect(item_names.include?('引き継ぎメイン1')).to eq true
          expect(item_names.include?('引き継ぎメイン2')).to eq true
          expect(item_names.include?('引き継ぎサイド1')).to eq true
          expect(item_names.include?('引き継ぎサイド2')).to eq true
          expect(item_names.include?('引き継ぎ消費済サイド')).to eq false
          expect(item_names.include?('主菜3')).to eq true
          expect(item_names.include?('主菜4')).to eq false
          expect(item_names.include?('副菜6')).to eq true
          expect(item_names.include?('副菜7')).to eq false
          expect(schedule.items.main.size).to eq 5
          expect(schedule.items.side.size).to eq 8
        end
      end

      context '引き継ぎが2品で両方残量50%の場合' do
        before do
          past_item_main1.update(remaining_rate: 50)
          past_item_main2.update(remaining_rate: 50)
          past_item_side1.update(remaining_rate: 50)
          past_item_side2.update(remaining_rate: 50)
        end

        it '1品分だけ作成済と判断され、初期作成の作り置きアイテムが1品分減ること' do
          schedule = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params, initial_count_params, past_schedule.id).schedule

          item_names = schedule.items.map(&:name)
          expect(item_names.include?('引き継ぎメイン1')).to eq true
          expect(item_names.include?('引き継ぎメイン2')).to eq true
          expect(item_names.include?('引き継ぎサイド1')).to eq true
          expect(item_names.include?('引き継ぎサイド2')).to eq true
          expect(item_names.include?('引き継ぎ消費済サイド')).to eq false
          expect(item_names.include?('主菜3')).to eq true
          expect(item_names.include?('主菜4')).to eq false
          expect(item_names.include?('副菜6')).to eq true
          expect(item_names.include?('副菜7')).to eq false
          expect(schedule.items.main.size).to eq 5
          expect(schedule.items.side.size).to eq 8
        end
      end

      context '引き継ぎが2品で両方残量30%の場合' do
        before do
          past_item_main1.update(remaining_rate: 30)
          past_item_main2.update(remaining_rate: 30)
          past_item_side1.update(remaining_rate: 30)
          past_item_side2.update(remaining_rate: 30)
        end

        it '作成済の作り置きは無しと判断され、初期作成の作り置きアイテムの数は指定通りになること' do
          schedule = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params, initial_count_params, past_schedule.id).schedule

          item_names = schedule.items.map(&:name)
          expect(item_names.include?('引き継ぎメイン1')).to eq true
          expect(item_names.include?('引き継ぎメイン2')).to eq true
          expect(item_names.include?('引き継ぎサイド1')).to eq true
          expect(item_names.include?('引き継ぎサイド2')).to eq true
          expect(item_names.include?('引き継ぎ消費済サイド')).to eq false
          expect(item_names.include?('主菜4')).to eq true
          expect(item_names.include?('副菜7')).to eq true
          expect(schedule.items.main.size).to eq 6
          expect(schedule.items.side.size).to eq 9
        end
      end
    end
  end
end
