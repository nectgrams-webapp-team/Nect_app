class TeamMembersController < ApplicationController
    def index
        @team_members = TeamMember.all
        @team = Team.find(params[:team_id])
    end
    
    def show

    end

    def new
        #@team = Team.new
    end

    def create
      team_member = TeamMember.new(team_member_params)
      team_member.approved = false
      team_member.save
      redirect_back(fallback_location: root_path)
    end

    def edit
      #@team = Team.find(params[:id])
    end

    def update
      team_id = params[:id]
      member_id = params[:format]
      @team_member = TeamMember.find_by(team_id: team_id, member_id: member_id)
      @team_member.update(approved: true)
      redirect_back(fallback_location: root_path)
    end

    def destroy
      team_id = params[:id]
      member_id = params[:format]
      team_member = TeamMember.find_by(team_id: team_id, member_id: member_id)
      team_member.destroy
      redirect_back(fallback_location: root_path)
    end

    private
    def team_member_params
        params.require(:team_member).permit(:team_id, :member_id)
    end
end
