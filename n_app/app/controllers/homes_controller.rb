class HomesController < ApplicationController
  def top
    @activities = Activity.where(published: true).last(6).reverse
    @images = Home.all
  end

  def about
    @event_history = EventHistory.all
  end
end
