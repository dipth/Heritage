module Heritage
  module ActiveRecord
    module ActsAsHeir
      
      def child_of(parent_symbol)
        acts_as_heir_of(parent_symbol)
      end

      def acts_as_heir_of(predecessor_symbol)
        extend ClassMethods
        include InstanceMethods

        class_attribute :_predecessor_klass, :_predecessor_symbol
        self._predecessor_symbol = predecessor_symbol
        self._predecessor_klass = Object.const_get(predecessor_symbol.to_s.camelize)

        has_one :predecessor, :as => :heir, :class_name => predecessor_symbol.to_s.camelize, :autosave => true, :dependent => :destroy

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

        # Include validations from the predecessor
        self._predecessor_klass.validators.each do |validator|
          self.validates_with(validator.class, :attributes => validator.attributes, :options => validator.options)
        end

        # We need to make sure that updated_at values in the predecessor table is updated when the heir is saved.
        before_update :touch_predecessor, :unless => lambda { predecessor.changed? }

        # Expose methods from predecessor
        self._predecessor_klass.get_heritage_exposed_methods.each do |method_symbol|
          define_method(method_symbol.to_s) do |*args|
            predecessor.send(method_symbol.to_s, *args)
          end
        end

        # This piece deals with errors names
        # and simply strips "predecessor." part from all the predecessor errors.
        after_validation do
          new_errors = {}
          keys_to_delete = []
          errors.each do |e|
            if e =~ /^predecessor/
              new_e = e.to_s.sub("predecessor.", '')
              new_errors[new_e] = errors[e].first
              keys_to_delete << e
            end
          end
          keys_to_delete.each { |k|   errors.delete(k) }
          new_errors.each     { |k,v| errors.add(k, v) }
        end
      end

      module ClassMethods

      end

      module InstanceMethods
        def heritage
          predecessor
        end

        def lineage
          self
        end

        def predecessor_with_build(attributes = {})
          predecessor_without_build || build_predecessor(attributes)
        end

        def touch_predecessor
          if self.changed?
            predecessor.touch
          end
        end
      end

    end
  end
end