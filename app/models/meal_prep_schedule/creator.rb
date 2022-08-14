class MealPrepSchedule::Creator
  INITAL_ITEM_PARAMS = [
    { name: '主菜1', meal_type: :main },
    { name: '主菜2', meal_type: :main },
    { name: '主菜3', meal_type: :main },
    { name: '主菜4', meal_type: :main },
    { name: '副菜1', meal_type: :side },
    { name: '副菜2', meal_type: :side },
    { name: '副菜3', meal_type: :side },
    { name: '副菜4', meal_type: :side },
    { name: '副菜5', meal_type: :side },
    { name: '副菜6', meal_type: :side },
    { name: '副菜7', meal_type: :side },
  ].freeze

  def create_schedule!(meal_prep_schedule_params)
    meal_prep_schedule = MealPrepSchedule.new(meal_prep_schedule_params)

    ActiveRecord::Base.transaction do
      result = meal_prep_schedule.save!

      INITAL_ITEM_PARAMS.each do |item_param|
        meal_prep_schedule.items.create!(item_param)
      end
    end

    Result.new(schedule: meal_prep_schedule)
  rescue
    Result.new(succeeded: false)
  end

  class Result
    attr_reader :schedule, :succeeded

    def initialize(schedule: nil, succeeded: true)
      @schedule = schedule
      @succeeded = succeeded
    end
  end
end
