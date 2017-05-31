Refinery::Blog::Admin::PostsController.prepend(
  Module.new do
    def permitted_post_params
      super << [
        :featured_image_id,
        :featured_image_url
      ]
    end
  end
)
