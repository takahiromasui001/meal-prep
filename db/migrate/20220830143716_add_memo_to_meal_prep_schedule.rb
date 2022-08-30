class AddMemoToMealPrepSchedule < ActiveRecord::Migration[7.0]
  def change
    add_column :meal_prep_schedules, :memo, :text, comment: 'メモ'
  end
end
