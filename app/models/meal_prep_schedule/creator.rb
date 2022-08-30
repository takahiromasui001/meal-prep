class MealPrepSchedule::Creator
  INITIAL_MAIN_COUNT = 4
  INITIAL_SIDE_COUNT = 7

  def create_schedule!(meal_prep_schedule_params, initial_count_params)
    meal_prep_schedule = MealPrepSchedule.new(meal_prep_schedule_params)

    ActiveRecord::Base.transaction do
      result = meal_prep_schedule.save!

      create_initial_item_params(initial_count_params).each do |item_param|
        meal_prep_schedule.items.create!(item_param)
      end
    end

    Result.new(schedule: meal_prep_schedule)
  rescue
    Result.new(succeeded: false)
  end

  def create_initial_item_params(initial_count_params)
    initial_count_hash = initial_count_params.to_h.map {|k, v| [k.to_sym, v.to_i]}.to_h
    main_count = initial_count_hash[:main_count]
    side_count = initial_count_hash[:side_count]

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
