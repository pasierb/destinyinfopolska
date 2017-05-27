Refinery::Authentication::Devise::Admin::UsersController.prepend(
  Module.new do
    def user_params
      super.to_h.merge(params.require(:user).permit(:profile_image_id, :twitch_username, :description))
    end
  end
)
