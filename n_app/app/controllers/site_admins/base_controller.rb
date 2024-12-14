module SiteAdmins
    class SiteAdmins::BaseController < ApplicationController
        before_action :validate_access_permission

        def validate_access_permission
            unless current_member.mod? or current_member.admin?
                flash[:error] = "You must be an admin or a mod to have access"
                redirect_to root_path
            end
        end

        def index
        end
    end
end
