class ImagePost < ActiveRecord::Base
  
  acts_as_heir_of :post
  
end
