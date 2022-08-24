class MealPrepSchedule::Item < ApplicationRecord
  belongs_to :schedule, class_name: 'MealPrepSchedule', foreign_key: "meal_prep_schedule_id"
  validates :name, presence: true

  enum :meal_type, { main: 0, side: 1 }
end
