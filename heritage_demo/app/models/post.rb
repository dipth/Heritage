class Post < ActiveRecord::Base
  
  acts_as_predecessor :exposes => :hello
  
  belongs_to :category
  
  def hello
    "Hi there!"
  end
  
end
