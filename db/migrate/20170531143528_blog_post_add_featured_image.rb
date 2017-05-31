class BlogPostAddFeaturedImage < ActiveRecord::Migration
  def change
    add_column :refinery_blog_posts, :featured_image_id, :integer
    add_column :refinery_blog_posts, :featured_image_url, :string
  end
end
