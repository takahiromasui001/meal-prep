# frozen_string_literal: true

module MealPrepScheduleDecorator
  def schedule_status
    meal_prep_items = items.includes(:items)
    mains = meal_prep_items.where(meal_type: :main)
    sides = meal_prep_items.where(meal_type: :side)

    tag.div do
      concat tag.div "主菜作り置き: #{mains.where(prepared: true).size} / #{mains.size}"
      concat tag.div "副菜作り置き: #{sides.where(prepared: true).size} / #{sides.size}"
    end
  end
end
