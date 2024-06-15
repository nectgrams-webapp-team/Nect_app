class HomesController < ApplicationController
  def top
  end

  def about
    @activities = Activity.all
  end
end
