require 'rails'

module Heritage
  
  class Railtie < Rails::Railtie
    
    initializer 'heritage' do |app|
      
      ActiveSupport.on_load(:active_record) do
        require 'heritage/active_record/acts_as_predecessor'
        require 'heritage/active_record/acts_as_heir'
        ::ActiveRecord::Base.send(:extend, Heritage::ActiveRecord::ActsAsPredecessor)
        ::ActiveRecord::Base.send(:extend, Heritage::ActiveRecord::ActsAsHeir)
      end
      
    end
    
  end
  
end