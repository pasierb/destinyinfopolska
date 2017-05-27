Refinery::Authentication::Devise::Admin::UsersController.prepend(
  Module.new do
    def user_params
      super.to_h.merge(params.require(:user).permit(
        :profile_image_id,
        :twitter_username,
        :description,
        :twitch_username,
        :psn_username,
        :xbl_username,
        :youtube_username,
        :bungie_profile_id
      ))
    end
  end
)
