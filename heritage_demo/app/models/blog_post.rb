class BlogPost < ActiveRecord::Base
  
  acts_as_heir_of :post
  
  validates_presence_of :body
  validates_presence_of :title
  
  def hello
    "Yo! #{predecessor.hello}"
  end
  
end
