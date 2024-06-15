class SiteAdminsController < ApplicationController
  before_action :validate_access_permission
  before_action :check_for_mod, only: [:admin_index, :member_editor, :increment_grade, :decrement_grade]
  before_action :check_for_admin, only: [:admin_index, :member_editor, :destroy, :grant_mod_status, :revoke_mod_status, :increment_grade, :decrement_grade]

  def validate_access_permission
    if current_member.member_role == "user"
      flash[:error] = "You must be an admin or a mod to have access"
      redirect_to root_path
    end
  end

  def check_for_mod
    if current_member.member_role == "mod"
    end
  end

  def check_for_admin
    if current_member.member_role == "admin"
    end
  end

  def admin_index
  end
  
  def member_editor
    @members = Member.all
    respond_to do |format|
      format.html
      format.xlsx do
        filename = "Member_Data_Export_#{Time.now.strftime('%Y%m%d')}.xlsx"
        
        p = Axlsx::Package.new
        p.workbook.add_worksheet(name: "Member Data Sheet") do |sheet|
          
          sheet.add_row ["Name", "Department", "Grade", "Student ID"]

          @members.each do |record|
            sheet.add_row [record.name, record.department, record.grade, record.student_id]
          end
        end

        send_data p.to_stream.read, filename: filename, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      end
    end
  end

  def increment_grade
    @members = Member.all
    @members.where.not(grade: 5).update_all('grade = grade + 1')
    redirect_to member_editor_path, notice: "Grades incremented successfully!"
  end

  def decrement_grade
    @members = Member.all
    @members.where.not(grade: 1).update_all('grade = grade - 1')
    redirect_to member_editor_path, notice: "Grades decremented successfully!"
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    @team = Team.where(master_id: @member.id)
    @team.each do |team|
      team.destroy
    end
    redirect_to member_editor_path
  end

  def grant_mod_status
    @member = Member.find(params[:id])
    if @member.update(member_role: 1)
      redirect_to request.referrer
    else
      render :member_editor 
    end
  end

  def revoke_mod_status
    @member = Member.find(params[:id])
    if @member.update(member_role: 0)
      redirect_to request.referrer
    else
      render :member_editor
    end
  end
end
