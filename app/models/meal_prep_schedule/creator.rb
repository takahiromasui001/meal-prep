class MealPrepSchedule::Creator
  MAIN_COUNT = 4
  SIDE_COUNT = 7

  def create_schedule!(meal_prep_schedule_params)
    meal_prep_schedule = MealPrepSchedule.new(meal_prep_schedule_params)
    result = meal_prep_schedule.save

    main_items =
      Array.new(MAIN_COUNT).map.with_index(1) do |_, i|
        { name: "主菜#{i}", meal_type: :main }
      end
    side_items =
      Array.new(SIDE_COUNT).map.with_index(1) do |_, i|
        { name: "副菜#{i}", meal_type: :side }
      end
    item_params = main_items + side_items
    item_params.each do |item_param|
      meal_prep_schedule.items.create!(item_param)
    end

    Result.new(schedule: meal_prep_schedule)
  end

  class Result
    attr_reader :schedule

    def initialize(schedule:)
      @schedule = schedule
    end
  end
end
