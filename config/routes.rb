Rails.application.routes.draw do
  root 'meal_prep_schedules#index'
  resources :meal_prep_schedules
end
