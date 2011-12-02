class BlogPost < ActiveRecord::Base
  
  child_of :post
  
  validates_presence_of :body
  validates_presence_of :title
  
  def hello
    "Yo! #{predecessor.hello}"
  end
  
end
