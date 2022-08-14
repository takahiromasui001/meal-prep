class MealPrepSchedule::Item < ApplicationRecord
  belongs_to :meal_prep_schedule

  enum :meal_type, { main: 0, side: 1 }
end
