class SiteAdminsController < ApplicationController
  before_action :validate_access_permission
  before_action :check_for_admin, only: [:destroy, :grant_mod_status, :revoke_mod_status]

  def validate_access_permission
    unless current_member.member_role == "admin" || current_member.member_role == "mod"
      flash[:error] = "You must be an admin or a mod to have access"
      redirect_to root_path
    end
  end

  def check_for_admin
    unless current_member.member_role == "admin"
      flash[:error] = "You must be an admin to access this section"
      redirect_to root_path
    end
  end

  def admin_index
  end
  
  # Below here are the functions pertaining to the modifications of members by the mods or the admin
  def member_editor
    @members = Member.all

    # I am paying for my incompetence here... sad!
    @grades = ['1年生', '2年生', '3年生', '4年生', 'OM']
    @memberCount = @members.count
    @count = @members.group(:grade).count

    @totalDepartmentCount = @members.group(:department).count

    @grouped_members = @members.group_by{|member| [member.grade, member.department]}
    @departmentCount = @grouped_members.transform_values(&:count)

    respond_to do |format|
      format.html
      format.xlsx do
        filename = "member_data_export_#{Time.now.strftime('%Y%m%d')}.xlsx"
        
        p = Axlsx::Package.new
        p.workbook.add_worksheet(name: "Member Data Sheet") do |sheet|
          
          sheet.add_row ["Student ID", "Name", "Grade", "Department"]

          @members.each do |record|
            sheet.add_row [record.student_id, record.name, record.grade, record.department]
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

  # Below here are the functions pertaining to modifying the images of the carousel in the top page
  def carousel_editor
    @images = Home.all
    @new_image = Home.new
  end

  def create_image
    @image = Home.new(image_params)
    if @image.save
      redirect_to request.referrer, notice: "Image successfully uploaded!"
    else
      render :new_image
    end
  end
  
  def update_image
    @image = Home.find(params[:id])
    if @image.update(image_params)
      redirect_to request.referrer, notice: 'Image was successfully updated.'
    else
      render :edit_image
    end
  end

  def delete_image
    @image = Home.find(params[:id])
    @image.destroy
    redirect_to request.referrer, notice: "Image was successfully deleted"
  end

  # Below here are the functions pertaining to events in the about page
  def event_history_editor
    @event_history = EventHistory.all
    @new_event_history = EventHistory.new
  end

  def create_event_history
    @event_history = EventHistory.new(event_history_params)
    if @event_history.save
      redirect_to request.referrer, notice: "New Event Added!"
    else
      render :event_history_editor
    end
  end

  def update_event_history
    @event_history = EventHistory.find(params[:id])
    if @event_history.update(event_history_params)
      redirect_to request.referrer, notice: "Event Successfully Updated!"
    else
      render :event_history_editor
    end
  end

  def delete_event_history
    @event_history = EventHistory.find(params[:id])
    @event_history.destroy
    redirect_to request.referrer, notice: "Event Successfully Deleted!"
  end

  private

  def event_history_params
    params.require(:event_history).permit(:event_title, :event_text, :date_of_event)
  end

  def image_params
    params.require(:home).permit(:title, :caption, :file)
  end
end
