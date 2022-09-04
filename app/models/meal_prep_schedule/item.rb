class MealPrepSchedule::Item < ApplicationRecord
  belongs_to :schedule, class_name: 'MealPrepSchedule', foreign_key: "meal_prep_schedule_id"
  validates :name, presence: true
  validate :remaining_rate_can_not_update_in_unprepared_item
  validates :remaining_rate, numericality: {greater_than_or_equal_to: 0,less_than_or_equal_to: 100}

  enum :meal_type, { main: 0, side: 1 }

  scope :prepared, -> { where(prepared: true).where.not(remaining_rate: 0) }
  scope :consumed, -> { where(remaining_rate: 0) }

  def remaining_rate_can_not_update_in_unprepared_item
    if prepared.blank? && remaining_rate != 100
      errors.add(:remaining_rate, 'cannot be update when item is not prepared')
    end
  end

  def meal_point
    remaining_rate.to_f / 100
  end
end
