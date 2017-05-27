Refinery::Authentication::Devise::User.class_eval do
  belongs_to :profile_image, :class_name => '::Refinery::Image'
end
