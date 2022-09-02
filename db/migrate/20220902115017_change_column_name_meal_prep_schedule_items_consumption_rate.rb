class ChangeColumnNameMealPrepScheduleItemsConsumptionRate < ActiveRecord::Migration[7.0]
  def change
    rename_column :meal_prep_schedule_items, :remaining_rate, :remaining_rate
    change_column :meal_prep_schedule_items, :remaining_rate, :integer, null: false, default: 100, comment: '残量(%)'
    
  end
end
