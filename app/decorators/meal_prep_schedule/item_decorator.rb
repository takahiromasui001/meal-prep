# frozen_string_literal: true

module MealPrepSchedule::ItemDecorator
  def prepared_label
    prepared? ? '(prepared)' : ''
  end
end
