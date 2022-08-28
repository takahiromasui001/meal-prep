class MealPrepSchedule::Item < ApplicationRecord
  belongs_to :schedule, class_name: 'MealPrepSchedule', foreign_key: "meal_prep_schedule_id"
  validates :name, presence: true
  validate :consumption_rate_can_not_update_in_unprepared_item
  validates :consumption_rate, numericality: {greater_than_or_equal_to: 0,less_than_or_equal_to: 100}

  enum :meal_type, { main: 0, side: 1 }

  def consumption_rate_can_not_update_in_unprepared_item
    if prepared.blank? && consumption_rate != 0
      errors.add(:consumption_rate, 'cannot be update when item is not prepared')
    end
  end
end
