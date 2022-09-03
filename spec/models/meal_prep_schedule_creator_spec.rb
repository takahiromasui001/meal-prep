require 'rails_helper'

RSpec.describe MealPrepSchedule::Creator, type: :model do
  describe '#create_schedule!' do
    let(:meal_prep_schedule_params) { { name: 'スケジュール1'} }

    it '作り置きスケジュール作成と同時に、アイテムも作成されること' do
      meal_prep_schedule_params = { name: 'スケジュール1'}
      initial_count_params = { main_count: 4, side_count: 7 }

      schedule = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params, initial_count_params).schedule

      expect(schedule.name).to eq 'スケジュール1'
      expect(schedule.items.where(meal_type: :main).size).to eq 4
      expect(schedule.items.where(meal_type: :side).size).to eq 7
    end

    context '作り置きを引き継ぐ場合' do
      let!(:past_schedule) { create(:meal_prep_schedule) }
      let!(:past_item1) { create(:meal_prep_schedule_item, name: '引き継ぎメイン', prepared: true, meal_type: :main, meal_prep_schedule_id: past_schedule.id) }
      let!(:past_item2) { create(:meal_prep_schedule_item, name: '引き継ぎサイド', prepared: true, meal_type: :side, meal_prep_schedule_id: past_schedule.id) }
      let!(:past_item3) { create(:meal_prep_schedule_item, name: '引き継ぎ消費済サイド', prepared: true, meal_type: :side, remaining_rate: 0, meal_prep_schedule_id: past_schedule.id) }

      it '作り置きスケジュール作成時に、以前のスケジュールの未消化のアイテムが引き継がれること' do
        meal_prep_schedule_params = { name: 'スケジュール1'}
        initial_count_params = { main_count: 4, side_count: 7 }
  
        schedule = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params, initial_count_params, past_schedule.id).schedule

        expect(schedule.items.map(&:name).include?('引き継ぎメイン')).to eq true
        expect(schedule.items.map(&:name).include?('引き継ぎサイド')).to eq true
        expect(schedule.items.map(&:name).include?('引き継ぎ消費済さいど')).to eq false
        expect(schedule.items.main.size).to eq 4
        expect(schedule.items.side.size).to eq 7
      end
    end
  end
end
