require 'rails_helper'

RSpec.describe MealPrepSchedule::Creator, type: :model do
  describe '#create_schedule!' do
    let(:meal_prep_schedule_params) { { name: 'スケジュール1'} }

    it '作り置きスケジュール作成と同時に、アイテムも作成されること' do
      meal_prep_schedule_params = { name: 'スケジュール1'}
      
      schedule = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params).schedule

      expect(schedule.name).to eq 'スケジュール1'
      expect(schedule.items.where(meal_type: :main).size).to eq 4
      expect(schedule.items.where(meal_type: :side).size).to eq 7
    end

    describe '誤ったアイテムが作成された場合' do
      let!(:invalid_params) { [ { meal_type: :main } ] }

      it 'スケジュールとアイテムの両方が作成されないこと' do
        stub_const("MealPrepSchedule::Creator::INITAL_ITEM_PARAMS", invalid_params)

        result = MealPrepSchedule::Creator.new.create_schedule!(meal_prep_schedule_params)
        expect(result.succeeded).to eq false
        expect(result.schedule).to eq nil
        expect(MealPrepSchedule.all.size).to eq 0
        expect(MealPrepSchedule::Item.all.size).to eq 0
      end
    end
  end
end
