class MembersController < ApplicationController
  def index
    @members = Member.all
  end

  def show
    @member = Member.find(params[:id])
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    member = Member.find(params[:id])
    member.update(members_params)
    redirect_to member_path(member.id)
  end

  private
  def members_params
    params.require(:member).permit(:name)
  end
end
