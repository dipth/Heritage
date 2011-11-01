module Heritage
  module ActiveRecord
    module ActsAsHeir

      def acts_as_heir_of(predecessor_symbol)
        extend ClassMethods
        include InstanceMethods

        class_attribute :_predecessor_klass, :_predecessor_symbol
        self._predecessor_symbol = predecessor_symbol
        self._predecessor_klass = Object.const_get(predecessor_symbol.to_s.capitalize)

        has_one :predecessor, :as => :heir, :class_name => predecessor_symbol.to_s.capitalize, :autosave => true, :dependent => :destroy

        alias_method_chain :predecessor, :build

        # Expose columns from the predecessor
        self._predecessor_klass.columns.reject{|c| c.primary || c.name =~ /^heir_/}.map(&:name).each do |att|
          define_method(att) do
            predecessor.send(att)
          end
          define_method("#{att}=") do |val|
            predecessor.send("#{att}=",val)
          end
        end

        # Expose associations from the predecessor
        self._predecessor_klass.reflect_on_all_associations.reject{|a| a.name == :heir}.each do |association|
          define_method(association.name) do
            predecessor.send(association.name)
          end
          define_method("#{association.name}=") do |val|
            predecessor.send("#{association.name}=",val)
          end
        end

        # We need to make sure that updated_at values in the predecessor table is updated when the heir is saved.
        after_update :touch_predecessor
        
        # Expose methods from predecessor
        self._predecessor_klass.get_heritage_exposed_methods.each do |method_symbol|
          define_method(method_symbol.to_s) do |*args|
            if args.length > 0
              predecessor.send(method_symbol.to_s, args)
            else
              predecessor.send(method_symbol.to_s)
            end
          end
        end
      end

      module ClassMethods

      end

      module InstanceMethods
        def predecessor_with_build(attributes = {})
          predecessor_without_build || build_predecessor(attributes)
        end

        def touch_predecessor
          predecessor.touch
        end
      end

    end
  end
end