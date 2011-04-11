class ImagePostsController < ApplicationController
  
  def index
    @image_posts = ImagePost.all
  end
  
  def new
    @image_post = ImagePost.new
  end
  
  def create
    @image_post = ImagePost.new(params[:image_post])
    
    if @image_post.save
      redirect_to image_posts_url
    else
      render :action => 'new'
    end
  end
  
  def show
    @image_post = ImagePost.find(params[:id])
  end
  
  def edit
    @image_post = ImagePost.find(params[:id])
  end
  
  def update
    @image_post = ImagePost.find(params[:id])
    
    if @image_post.update_attributes(params[:image_post])
      redirect_to image_posts_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @image_post = ImagePost.find(params[:id])
    @image_post.destroy
    redirect_to image_posts_url
  end
  
end
