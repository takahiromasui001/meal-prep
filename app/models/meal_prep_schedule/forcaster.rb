class MealPrepSchedule::Forcaster
  MAIN_MEAL_POINT_PER_DATE = 0.6
  SIDE_MEAL_POINT_PER_DATE = 1.3

  def consumption_days_forecast(schedule)
    # NOTE: meal_point = 残量(remaining_rate) ÷ 100
    prepared_meal_point = schedule.items.prepared.sum(:remaining_rate).to_f / 100
    (prepared_meal_point / consumption_meal_point_per_date).floor(1)
  end

  private

  def consumption_meal_point_per_date
    MAIN_MEAL_POINT_PER_DATE + SIDE_MEAL_POINT_PER_DATE
  end
end
