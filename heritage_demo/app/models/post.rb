class Post < ActiveRecord::Base
  
  acts_as_predecessor :exposes => :hello
  
  def hello
    "Hi there!"
  end
  
end
