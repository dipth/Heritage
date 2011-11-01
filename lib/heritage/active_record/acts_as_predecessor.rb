module Heritage
  module ActiveRecord
    module ActsAsPredecessor

      def acts_as_predecessor(options = {})
        extend ClassMethods
        include InstanceMethods

        options[:exposes] ||= []
        class_attribute :_acts_as_predecessor_settings
        self._acts_as_predecessor_settings = options
        
        belongs_to :heir, :polymorphic => true, :touch => true
      end

      module ClassMethods

        def get_heritage_exposed_methods
          result = self._acts_as_predecessor_settings[:exposes]
          result.is_a?(Array) ? result : [result]
        end

      end

      module InstanceMethods
        
      end

    end
  end
end