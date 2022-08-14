class MealPrepSchedule::Item < ApplicationRecord
  belongs_to :meal_prep_schedule
  validates :name, presence: true

  enum :meal_type, { main: 0, side: 1 }
end
