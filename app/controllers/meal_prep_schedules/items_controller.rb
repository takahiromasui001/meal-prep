class MealPrepSchedules::ItemsController < ApplicationController
  def new
    schedule = MealPrepSchedule.find(params[:meal_prep_schedule_id])
    @meal_prep_item = schedule.items.build
  end

  def edit
    @meal_prep_item = load_meal_prep_item
  end

  def create
    @meal_prep_item = MealPrepSchedule::Item.new(meal_prep_item_params)

    if @meal_prep_item.save!
      redirect_to meal_prep_schedule_path(id: @meal_prep_item.schedule), notice: 'Meal prep item was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @meal_prep_item = load_meal_prep_item

    if @meal_prep_item.update(meal_prep_item_params)
      redirect_to meal_prep_schedule_path(id: @meal_prep_item.schedule), notice: 'Meal prep item was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @meal_prep_item = load_meal_prep_item
    @meal_prep_item.destroy!

    redirect_to meal_prep_schedule_path(@meal_prep_item.schedule), notice: 'Meal prep item was successfully destroyed.'
  end

  private

  def load_meal_prep_item
    schedule = MealPrepSchedule.find(params[:meal_prep_schedule_id])
    schedule.items.find(params[:id])
  end

  def meal_prep_item_params
    params.require(:meal_prep_schedule_item).permit(:name, :prepared, :meal_type, :remaining_rate, :meal_prep_schedule_id)
  end
end
