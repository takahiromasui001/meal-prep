require 'rails_helper'

RSpec.describe MealPrepSchedule::Creator, type: :model do
  describe '#create_schedule!' do
    it '作り置きスケジュール作成と同時に、アイテムも作成されること' do
      meal_prep_schedule_params = { name: 'スケジュール1'}
      
      schedule = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params).schedule

      expect(schedule.name).to eq 'スケジュール1'
      expect(schedule.items.where(meal_type: :main).size).to eq 4
      expect(schedule.items.where(meal_type: :side).size).to eq 7
    end
  end
end
