class CreateMealPrepItems < ActiveRecord::Migration[7.0]
  def change
    create_table :meal_prep_schedule_items, comment: '作り置きアイテム' do |t|
      t.string :name, null: false, comment: '名前'
      t.boolean :prepared, null: false, default: false, comment: '作成済み'
      t.integer :meal_type, null: false, comment: '作り置き種類'
      t.references :meal_prep_schedule, foreign_key: true, comment: '作り置きスケジュールID'

      t.timestamps
    end
  end
end
