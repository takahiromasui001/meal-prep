class CreateMealPrepSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :meal_prep_schedules do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
