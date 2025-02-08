class ApplicationController < ActionController::Base
  #before_action :configure_permitted_parameters, if: :devise_controller?
  before_action do
    I18n.locale = :ja
  end

  def after_sign_in_path_for(resource)
    member_path(current_member.id)
  end
end
