class HomesController < ApplicationController
  def top
    @activities = Activity.all
  end

  def about
  end
end
