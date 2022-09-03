FactoryBot.define do
  factory :meal_prep_schedule_item, class: MealPrepSchedule::Item do
    name { "item" }
    meal_type { :main }

    # association :schedule, factory: :meal_prep_schedule
  end
end