class MealPrepSchedules::ItemsController < ApplicationController
  before_action :set_meal_prep_item, only: %i[ show edit update destroy ]

  def index
    schedule = MealPrepSchedule.find(params[:meal_prep_schedule_id])
    @meal_prep_items = schedule.items.all
  end

  def show
  end

  def new
    schedule = MealPrepSchedule.find(params[:meal_prep_schedule_id])
    @meal_prep_item = schedule.items.build
  end

  def edit
  end

  def create
    @meal_prep_item = MealPrepSchedule::Item.new(meal_prep_item_params)

    if @meal_prep_item.save!
      redirect_to meal_prep_schedule_item_url(id: @meal_prep_item.id), notice: "Meal prep item was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @meal_prep_item.update(meal_prep_item_params)
      redirect_to meal_prep_schedule_path(id: @meal_prep_item.meal_prep_schedule), notice: "Meal prep item was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @meal_prep_item.destroy!

    redirect_to meal_prep_schedule_path(@meal_prep_item.meal_prep_schedule), notice: "Meal prep item was successfully destroyed."
  end

  private

  def set_meal_prep_item
    schedule = MealPrepSchedule.find(params[:meal_prep_schedule_id])
    @meal_prep_item = schedule.items.find(params[:id])
  end

  def meal_prep_item_params
    params.require(:meal_prep_schedule_item).permit(:name, :prepared, :meal_type, :meal_prep_schedule_id)
  end
end
