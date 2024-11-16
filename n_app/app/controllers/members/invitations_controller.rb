class Members::InvitationsController < Devise::InvitationsController
    before_action :configure_permitted_parameters

    def after_invite_path_for(resource)
        site_admins_members_manager_index_path
    end

    def update
        super do |resource|
            if resource.errors.empty?
                # ユーザーをログインさせる
                sign_in(resource)

                # ユーザーの招待受け入れが成功し、エラーがなければ編集ページにリダイレクト
                redirect_to edit_member_path(resource)
            else
                # エラーがある場合は、デフォルトの動作を維持（通常は再度招待ページをrenderする）
                respond_with_navigational(resource) { render :edit }
            end
            return # 重要: コントローラーアクションをここで終了させる
        end
    end

    protected

    # Permit the new params here.
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name, :student_id])
    end
end
