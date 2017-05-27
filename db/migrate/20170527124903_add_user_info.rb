class AddUserInfo < ActiveRecord::Migration
  def change
    add_column :refinery_authentication_devise_users, :profile_image_id, :integer
    add_column :refinery_authentication_devise_users, :twitch_username, :string
    add_column :refinery_authentication_devise_users, :description, :text
  end
end
