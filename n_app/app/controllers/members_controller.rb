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
    sum_languages = selected_languages.sum
    @member.learning_programming_languages = sum_languages

    selected_frameworks = Array(members_params[:selected_frameworks]).map(&:to_i)
    sum_frameworks = selected_frameworks.sum
    @member.learning_frameworks = sum_frameworks

    selected_libraries = Array(members_params[:selected_libraries]).map(&:to_i)
    sum_libraries = selected_libraries.sum
    @member.learning_libraries = sum_libraries

    selected_game_engines = Array(members_params[:selected_game_engines]).map(&:to_i)
    sum_game_engines = selected_game_engines.sum
    @member.learning_game_engines = sum_game_engines

    selected_graphics_3d = Array(members_params[:selected_graphics_3d]).map(&:to_i)
    sum_graphics_3d = selected_graphics_3d.sum
    @member.learning_graphics_3D = sum_graphics_3d

    if @member.update(members_params.except(:selected_languages, :selected_frameworks, :selected_libraries, :selected_game_engines, :selected_graphics_3d))
      redirect_to member_path(@member.id)
    else
      render :edit
    end
  end

  private

  def members_params
    params.require(:member).permit(:name, :email, :student_id, :grade, :intro, :profile_image, :department, :graduation_year, :course, selected_languages: [], selected_frameworks: [], selected_libraries: [], selected_game_engines: [], selected_graphics_3d: [])
  end
end
