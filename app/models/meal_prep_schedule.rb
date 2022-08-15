class MealPrepSchedule < ApplicationRecord
  has_many :items, dependent: :destroy

  def prepared_items
    items.includes(:items).where(prepared: true)
  end
end
