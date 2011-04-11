class CreateImagePosts < ActiveRecord::Migration
  def self.up
    create_table :image_posts do |t|
      t.integer :aspect
    end
  end

  def self.down
    drop_table :image_posts
  end
end
