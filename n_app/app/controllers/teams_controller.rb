class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def show
    @team = Team.find(params[:id])
    #@team_member = TeamMember.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    team = Team.new(team_params)
    team.master_id = current_member.id
    team.save
    redirect_to teams_path
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    activity = Activity.find(params[:id])
    activity.update(activity_params)
    redirect_to activity_path
  end

  def destroy
    activity = Activity.find(params[:id])
    activity.delete
    redirect_to activities_path
  end

  private
  def team_params
    params.require(:team).permit(:name, :introduction)
  end
end