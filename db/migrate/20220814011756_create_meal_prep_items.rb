class CreateMealPrepItems < ActiveRecord::Migration[7.0]
  def change
    create_table :meal_prep_schedule_items do |t|
      t.string :name, null: false
      t.boolean :prepared, null: false
      t.integer :meal_type, null: false
      t.references :meal_prep_schedule, foreign_key: true

      t.timestamps
    end
  end
end
