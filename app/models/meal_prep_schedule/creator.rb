class MealPrepSchedule::Creator
  def create_schedule!(meal_prep_schedule_params)
    meal_prep_schedule = MealPrepSchedule.new(meal_prep_schedule_params)
    initial_item_params = create_initial_item_params

    ActiveRecord::Base.transaction do
      result = meal_prep_schedule.save!

      initial_item_params.each do |item_param|
        meal_prep_schedule.items.create!(item_param)
      end
    end

    Result.new(schedule: meal_prep_schedule)
  rescue
    Result.new(succeeded: false)
  end

  def create_initial_item_params
    main_count = 4
    side_count = 7

    main_params = (1..main_count).map { |i| { name: "主菜#{i}", meal_type: :main } }
    side_params = (1..side_count).map { |i| { name: "副菜#{i}", meal_type: :side } }
    main_params + side_params
  end

  class Result
    attr_reader :schedule, :succeeded

    def initialize(schedule: nil, succeeded: true)
      @schedule = schedule
      @succeeded = succeeded
    end
  end
end
