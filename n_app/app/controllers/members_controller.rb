class MembersController < ApplicationController
  def index
    @members = Member.where.not(invitation_accepted_at: nil)
  end

  def show
    @member = Member.find(params[:id])
    @activities = Activity.where(member_id: @member.id)
    @count = Activity.where(member_id: @member.id).count
    @activities_published = @activities.where(published: true)
    @activities_draft = @activities.where(published: false)
  end

  def edit
    @member = Member.find(params[:id])

    unless @member == current_member
      redirect_to member_path(@member.id)
    end
  end

  def update
    @member = Member.find(params[:id])

    # Calculate and store the graduation year in db
    @member.graduation_year = @member.calculate_graduation_year(@member.student_id)

    # 選択された言語の値を合計
    selected_languages = Array(members_params[:selected_languages]).map(&:to_i)
    total_value = selected_languages.sum
    @member.learning_programming_languages = total_value

    # selected_languagesを除外してパラメータ保存
    if @member.update(members_params.except(:selected_languages))
      redirect_to member_path(@member.id)
    else
      render :edit
    end
  end

  private

  def members_params
    params.require(:member).permit(:name, :email, :student_id, :grade, :intro, :profile_image, :department, :graduation_year, :course, selected_languages: [])
  end
end
