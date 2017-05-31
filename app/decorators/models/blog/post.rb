Refinery::Blog::Post.class_eval do
  belongs_to :featured_image, :class_name => "::Refinery::Image"
end
