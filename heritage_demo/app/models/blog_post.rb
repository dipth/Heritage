class BlogPost < ActiveRecord::Base
  
  acts_as_heir_of :post
  
  def hello
    "Yo! #{predecessor.hello}"
  end
  
end
