class Members::InvitationsController < Devise::InvitationsController
  before_action :configure_permitted_parameters

  def update
    super
  end

  protected

  # Permit the new params here.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name, :student_id])
  end
end
