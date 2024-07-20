class HomesController < ApplicationController
  def top
    @activities = Activity.all
    @images = Home.all
  end

  def about
    @event_history = EventHistory.all
  end
end
