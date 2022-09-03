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

      it '作り置きスケジュール作成時に、以前のスケジュールの未消化のアイテムが引き継がれること' do
        schedule = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params, initial_count_params, past_schedule.id).schedule

        expect(schedule.items.map(&:name).include?('引き継ぎメイン1')).to eq true
        expect(schedule.items.map(&:name).include?('引き継ぎメイン2')).to eq true
        expect(schedule.items.map(&:name).include?('引き継ぎサイド1')).to eq true
        expect(schedule.items.map(&:name).include?('引き継ぎサイド2')).to eq true
        expect(schedule.items.map(&:name).include?('引き継ぎ消費済サイド')).to eq false
        expect(schedule.items.main.size).to eq 4
        expect(schedule.items.side.size).to eq 7

        past_item_main1.update(remaining_rate: 30)
        past_item_side1.update(remaining_rate: 30)
        schedule2 = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params, initial_count_params, past_schedule.id).schedule
        expect(schedule2.items.map(&:name).include?('引き継ぎメイン1')).to eq true
        expect(schedule2.items.map(&:name).include?('引き継ぎメイン2')).to eq true
        expect(schedule2.items.map(&:name).include?('引き継ぎサイド1')).to eq true
        expect(schedule2.items.map(&:name).include?('引き継ぎサイド2')).to eq true
        expect(schedule2.items.map(&:name).include?('引き継ぎ消費済サイド')).to eq false
        expect(schedule2.items.main.size).to eq 5
        expect(schedule2.items.side.size).to eq 8

        past_item_main2.update(remaining_rate: 30)
        past_item_side2.update(remaining_rate: 30)
        schedule3 = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params, initial_count_params, past_schedule.id).schedule
        expect(schedule3.items.map(&:name).include?('引き継ぎメイン1')).to eq true
        expect(schedule3.items.map(&:name).include?('引き継ぎメイン2')).to eq true
        expect(schedule3.items.map(&:name).include?('引き継ぎサイド1')).to eq true
        expect(schedule3.items.map(&:name).include?('引き継ぎサイド2')).to eq true
        expect(schedule3.items.map(&:name).include?('引き継ぎ消費済サイド')).to eq false
        expect(schedule3.items.main.size).to eq 6
        expect(schedule3.items.side.size).to eq 9
      end
    end
  end
end
