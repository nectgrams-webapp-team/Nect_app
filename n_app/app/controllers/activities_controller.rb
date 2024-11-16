class ActivitiesController < ApplicationController
  def index
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @activities = Activity.joins(:member)
                            .where('activities.title LIKE ? OR activities.body LIKE ? OR members.name LIKE ?', search_term, search_term, search_term)
                            .order(created_at: :desc)
                            .page(params[:page])
                            .per(10)
    else
      @activities = Activity.order(created_at: :desc).page(params[:page]).per(10)
    end
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def new
    @activity = Activity.new
  end

  def create
    @activity = Activity.new(activity_params)
    @activity.member_id = current_member.id
    if @activity.save
      redirect_to activities_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @activity = Activity.find(params[:id])
  end

  def update
    @activity = Activity.find(params[:id])

    if @activity.update(activity_params)
      redirect_to activity_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    activity = Activity.find(params[:id])
    activity.delete
    redirect_to activities_path
  end

  private
  def activity_params
    params.require(:activity).permit(:title, :body, :activity_image)
  end
end
