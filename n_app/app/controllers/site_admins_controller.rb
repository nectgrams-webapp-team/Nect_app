class SiteAdminsController < ApplicationController
  before_action :validate_admin

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
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy
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
