class AddConsumptionRateToMealPrepScheduleItems < ActiveRecord::Migration[7.0]
  def change
    add_column :meal_prep_schedule_items, :remaining_rate, :integer, null: false, default: 0, comment: '消化率'
  end
end
