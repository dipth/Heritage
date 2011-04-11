class PostsController < ApplicationController
  
  def index
    @posts = Post.all
  end
  
  def show
    @post = Post.find(params[:id])
    
    if @post.heir.is_a?(BlogPost)
      redirect_to blog_post_url(@post.heir)
    elsif @post.heir.is_a?(ImagePost)
      redirect_to image_post_url(@post.heir)
    else
      render :text => "Unknown post-type"
    end
  end
  
end
