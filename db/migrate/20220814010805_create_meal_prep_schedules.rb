class CreateMealPrepSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :meal_prep_schedules, comment: '作り置きスケジュール' do |t|
      t.string :name, null: false, comment: '名前'

      t.timestamps
    end
  end
end
