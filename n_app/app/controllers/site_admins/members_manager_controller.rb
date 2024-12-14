# frozen_string_literal: true

class SiteAdmins::MembersManagerController < SiteAdmins::BaseController
    before_action :validate_admin, only: [:destroy, :grant_mod_status, :revoke_mod_status, :resend_invitation]

    def validate_admin
        unless current_member.admin?
            flash[:error] = "You must be an admin to use this feature."
            redirect_to site_admins_members_manager_index_path
        end
    end

    def index
        @members = Member.all

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

    def destroy
        @member = Member.find(params[:id])
        @member.destroy

        @team = Team.where(master_id: @member.id)
        @team.each do |team|
            team.destroy
        end
        redirect_to site_admins_members_manager_index_path
    end

    def statistics
        @members = Member.all

        @member_count = @members.count
        @grade_count = @members.group(:grade).count

        @total_department_count = @members.group(:department).count

        @grouped_members = @members.group_by{|member| [member.grade, member.department]}
        @department_count = @grouped_members.transform_values(&:count)
    end

    def increment_grade
        @members = Member.all
        @members.where.not(grade: 5).update_all('grade = grade + 1')
        redirect_to site_admins_members_manager_index_path, notice: "Grades incremented successfully!"
    end

    def decrement_grade
        @members = Member.all
        @members.where.not(grade: 1).update_all('grade = grade - 1')
        redirect_to site_admins_members_manager_index_path, notice: "Grades decremented successfully!"
    end

    def grant_mod_status
        @member = Member.find(params[:id])

        if Member.mod.count < 4
            if @member.update(member_role: :mod)
                redirect_back(fallback_location: members_path, notice: "#{@member.name} has been granted mod status.")
            else
                flash[:alert] = "Unable to grant mod status to #{@member.name}. Please try again."
                render :index
            end
        else
            redirect_to site_admins_members_manager_index_path, notice: "Mod limit reached! Only 4 mods are allowed."
        end
    end

    def revoke_mod_status
        @member = Member.find(params[:id])
        if @member.update(member_role: :user)
            redirect_to request.referrer
        else
            render :index
        end
    end

    def grant_admin_status
        @member = Member.find(params[:id])

        if Member.admin.count < 3
            if @member.update(member_role: :admin)
                redirect_back(fallback_location: members_path, notice: "#{@member.name} has been granted admin status.")
            else
                flash[:alert] = "Unable to grant admin status to #{@member.name}. Please try again."
                render :index
            end
        else
            redirect_to site_admins_members_manager_index_path, notice: "Admin limit reached! Only 3 admins are allowed."
        end
    end

    def revoke_admin_status
        @member = Member.find(params[:id])
        if @member.update(member_role: :user)
            redirect_to request.referrer
        else
            render :index
        end
    end

    def resend_invitation
        @member = Member.find(params[:id])
        if @member.invite!.deliver!
            flash[:notice] = "Invitation mail successfully sent!"
            redirect_to site_admins_members_manager_index_path
        else
            flash[:alert] = "Invitation mail could not be sent!"
            redirect_to site_admins_members_manager_index_path
        end
    end
end
