# frozen_string_literal: true

module MealPrepSchedule::ItemDecorator
  def prepared_label
    prepared? ? "消化率: #{consumption_rate}%" : '(準備中)'
  end
end
