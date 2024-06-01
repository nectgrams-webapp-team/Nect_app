class MembersController < ApplicationController
  def index
    @members = Member.all
  end

  def show
    @member = Member.find(params[:id])
    # @member.grade = @member.calculate_grade(@member.student_id)
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    member = Member.find(params[:id])
    # member.grade = member.calculate_grade(member.student_id)
    if member.update(members_params)
      redirect_to member_path(member.id)
    else
      render :edit
    end
  end

  def increment_grade
    @members = Member.all
    @members.where.not(grade: 5).update_all('grade = grade + 1')
    puts 'Grades incremented successfully!'
  end

  def decrement_grade
    @members = Member.all
    @members.where.not(grade: 1).update_all('grade = grade - 1')
    puts 'Grades decremented successfully!'
  end

  private
  def members_params
    params.require(:member).permit(:name, :student_id, :grade)
  end
end
