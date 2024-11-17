class ActivitiesController < ApplicationController
  def index
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @activities = Activity.joins(:member)
                            .where('activities.published = ? AND (activities.title LIKE ? OR activities.body LIKE ? OR members.name LIKE ?)', true, search_term, search_term, search_term)
                            .order(created_at: :desc)
                            .page(params[:page])
                            .per(10)
    else
      @activities = Activity.where(published: true)
                            .order(created_at: :desc)
                            .page(params[:page])
                            .per(5)
    end
  end

  def show
    @activity = Activity.find(params[:id])
    @author = @activity.member
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

  def save_draft
    @activity = Activity.new(activity_params)
    @activity.member_id = current_member.id
    @activity.published = false

    if @activity.save
      redirect_to activities_path, notice: '下書きが保存されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def change_publish
    @activity = Activity.find(params[:id])
    @activity.assign_attributes(activity_params)
    if @activity.published
      @activity.update(published: false)
      notice_message = '記事が非公開になりました。'
    else
      @activity.update(published: true)
      notice_message = '記事が公開されました。'
    end

    if @activity.save
      redirect_to activity_path(@activity), notice: notice_message
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def activity_params
    params.require(:activity).permit(:title, :body, :activity_image, :published)
  end
end
