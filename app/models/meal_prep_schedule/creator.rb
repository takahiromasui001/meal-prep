class MealPrepSchedule::Creator
  def create_schedule!(meal_prep_schedule_params, initial_count_params, base_item_schedule_id = nil)
    meal_prep_schedule = MealPrepSchedule.new(meal_prep_schedule_params)

    ActiveRecord::Base.transaction do
      new_schedule = meal_prep_schedule.save!

      # 引き継ぎアイテムの作成
      # new_schedule.hand_over_meal_prep_schedule_items!(base_schedule_id)
      # Handover.hand_over_items!(new_schedule, base_schedule_id)

      base_schedule = MealPrepSchedule.find(1)
      base_schedule.items.prepared.map(&:dup).each do |item| {
        item.meal_prep_schedule_id = new_schedule.id
        item.save!
      }

      # meal pointから残りの要作成アイテムを計算
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
