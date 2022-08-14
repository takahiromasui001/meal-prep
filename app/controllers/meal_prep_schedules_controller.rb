class MealPrepSchedulesController < ApplicationController
  before_action :set_meal_prep_schedule, only: %i[ show edit update destroy ]

  def index
    @meal_prep_schedules = MealPrepSchedule.all
  end

  def show
  end

  def new
    @meal_prep_schedule = MealPrepSchedule.new
  end

  def edit
  end

  def create
    @meal_prep_schedule = MealPrepSchedule.new(meal_prep_schedule_params)

    if @meal_prep_schedule.save
      redirect_to meal_prep_schedule_url(@meal_prep_schedule), notice: "Meal prep schedule was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @meal_prep_schedule.update(meal_prep_schedule_params)
      redirect_to meal_prep_schedule_url(@meal_prep_schedule), notice: "Meal prep schedule was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @meal_prep_schedule.destroy

    redirect_to meal_prep_schedules_url, notice: "Meal prep schedule was successfully destroyed."
  end

  private

  def set_meal_prep_schedule
    @meal_prep_schedule = MealPrepSchedule.find(params[:id])
  end

  def meal_prep_schedule_params
    params.require(:meal_prep_schedule).permit(:name)
  end
end
