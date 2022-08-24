Rails.application.routes.draw do
  root 'meal_prep_schedules#index'
  resources :meal_prep_schedules do
    resources :items, controller: 'meal_prep_schedules/items', only: %i(new create edit update destroy)
  end
end
