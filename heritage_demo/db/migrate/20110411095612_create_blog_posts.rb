class CreateBlogPosts < ActiveRecord::Migration
  def self.up
    create_table :blog_posts do |t|
      t.text :body
    end
  end

  def self.down
    drop_table :blog_posts
  end
end
