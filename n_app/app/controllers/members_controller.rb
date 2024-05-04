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
    member = Member.find(params[:id])
    #member.grade = member.calculate_grade(member.student_id)
    if member.update(members_params)
      redirect_to member_path(member.id)
    else
      render :edit
    end
  end

  private
  def members_params
    params.require(:member).permit(:name, :student_id)
  end
end
