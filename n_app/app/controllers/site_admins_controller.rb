class SiteAdminsController < ApplicationController
  before_action :validate_admin, only: [:admin_index, :member_editor, :destroy, :grant_admin_status, :revoke_admin_status]

  def validate_admin
    if current_member.admin == false
      flash[:error] = "You must be an admin to access this section"
      redirect_to root_path
    end
  end

  def admin_index
  end
  
  def member_editor
    @members = Member.all
    respond_to do |format|
      format.html
      format.xlsx do
        filename = "Member_Data_Export_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
        
        p = Axlsx::Package.new
        p.workbook.add_worksheet(name: "Member Data Sheet") do |sheet|
          
          headers = Member.column_names
          sheet.add_row headers

          @members.each do |record|
            values = record.attributes.values
            sheet.add_row values
          end
        end

        send_data p.to_stream.read, filename: filename, type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      end
    end
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    @team = Team.find_by(master_id: @member.id)
    @team.destroy
    redirect_to member_editor_path
  end

  def grant_admin_status
    @member = Member.find(params[:id])
    if @member.update(admin: true)
      redirect_to request.referrer
    else
      render :member_editor 
    end
  end

  def revoke_admin_status
    @member = Member.find(params[:id])
    if @member.update(admin: false)
      redirect_to request.referrer
    else
      render :member_editor
    end
  end
end
