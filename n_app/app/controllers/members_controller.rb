class MembersController < ApplicationController
  def index
    @members = Member.all
  end

  def show
  end

  def edit
  end

  #private
  #def members_params
  #  params.require(:member).permit(:name)
  #end
end
