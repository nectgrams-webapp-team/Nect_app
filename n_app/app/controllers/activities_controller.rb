class ActivitiesController < ApplicationController
  def index
    @activities = Activity.all
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def new
    @activity = Activity.new
  end

  def create
    activity = Activity.new(activity_params)
    activity.save
    redirect_to activities_path
  end

  def edit
    @activity = Activity.find(params[:id])
  end

  def update
    activity = Activity.find(params[:id])
    activity.update(activity_params)
    redirect_to activity_path
  end

  def destroy
    activity = Activity.find(params[:id])
    activity.delete
    redirect_to activities_path
  end

  private
  def activity_params
    params.require(:activity).permit(:title, :body, :post_day, :activity_image)
  end
end
