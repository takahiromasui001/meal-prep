class MealPrepSchedule::Creator
  INITIAL_MAIN_COUNT = 4
  INITIAL_SIDE_COUNT = 7

  def create_schedule!(meal_prep_schedule_params, initial_count_params, base_item_schedule_id = nil)
    meal_prep_schedule = MealPrepSchedule.new(meal_prep_schedule_params)

    ActiveRecord::Base.transaction do
      meal_prep_schedule.save!

      # 引き継ぎ元のスケジュールから対象のアイテムを複製
      if base_item_schedule_id.present?
        duplicate_prepared_items(base_item_schedule_id, meal_prep_schedule.id)
      end

      # meal pointから残りの要作成アイテムを計算(小数点切り捨て)
      sum_of_prepared_main_meal_point = meal_prep_schedule.items.main.prepared.map(&:meal_point).sum
      sum_of_created_side_meal_point = meal_prep_schedule.items.side.prepared.map(&:meal_point).sum

      initial_count_params_2 = {
        main_count: initial_count_params[:main_count].to_i - sum_of_prepared_main_meal_point.floor,
        side_count: initial_count_params[:side_count].to_i - sum_of_created_side_meal_point.floor
      }

      create_initial_item_params(initial_count_params_2).each do |item_param|
        meal_prep_schedule.items.create!(item_param)
      end
    end

    Result.new(schedule: meal_prep_schedule)
  rescue
    Result.new(succeeded: false)
  end

  private

  def create_initial_item_params(initial_count_params)
    initial_count_hash = initial_count_params.to_h.map {|k, v| [k.to_sym, v.to_i]}.to_h
    main_count = initial_count_hash[:main_count]
    side_count = initial_count_hash[:side_count]

    main_params = (1..main_count).map { |i| { name: "主菜#{i}", meal_type: :main } }
    side_params = (1..side_count).map { |i| { name: "副菜#{i}", meal_type: :side } }
    main_params + side_params
  end

  def duplicate_prepared_items(base_item_schedule_id, meal_prep_schedule_id)
    base_schedule = MealPrepSchedule.find(base_item_schedule_id)
    base_schedule.items.prepared.map(&:dup).each do |item|
      item.meal_prep_schedule_id = meal_prep_schedule_id
      item.save!
    end
  end

  class Result
    attr_reader :schedule, :succeeded

    def initialize(schedule: nil, succeeded: true)
      @schedule = schedule
      @succeeded = succeeded
    end
  end
end
