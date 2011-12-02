class Post < ActiveRecord::Base
  
  parent_model :exposes => :hello
  
  belongs_to :category
  
  def hello
    "Hi there!"
  end
  
end
