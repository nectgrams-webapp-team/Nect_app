class MembersController < ApplicationController
  def index
    @members = Member.all
  end

  def show
    @member = Member.find(params[:id])
    @member.grade = @member.calculate_grade(@member.student_id)
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])

    #選択された言語の値を合計
    selected_languages = Array(members_params[:selected_languages]).map(&:to_i)
    total_value = selected_languages.sum
    @member.learning_programming_languages = total_value

    #selected_languagesを除外してパラメータ保存
    if @member.update(members_params.except(:selected_languages))
      redirect_to member_path(@member.id)
    else
      render :edit
    end
  end

  private
  def members_params
    params.require(:member).permit(:name, :student_id, :intro, :profile_image, selected_languages: [])
  end
end
