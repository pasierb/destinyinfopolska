class AddUserSocialLinks < ActiveRecord::Migration
  def change
    add_column :refinery_authentication_devise_users, :twitter_username, :string
    add_column :refinery_authentication_devise_users, :psn_username, :string
    add_column :refinery_authentication_devise_users, :xbl_username, :string
    add_column :refinery_authentication_devise_users, :youtube_username, :string
    add_column :refinery_authentication_devise_users, :bungie_profile_id, :string
  end
end
