module Heritage
  module ActiveRecord
    module ActsAsHeir
      
      def child_of(parent_symbol, params)
        acts_as_heir_of(parent_symbol, params)
      end

      def acts_as_heir_of(predecessor_symbol, params)
        extend ClassMethods
        include InstanceMethods

        class_attribute :_predecessor_klass, :_predecessor_symbol
        self._predecessor_symbol = predecessor_symbol
        if defined? params and not params.nil? and defined? params[:class] and not params[:class].nil? then
          self._predecessor_klass = params[:class].constantize
        else
          self._predecessor_klass = predecessor_symbol.constantize
        end

        has_one :predecessor, :as => :heir, :class_name => self._predecessor_klass.to_s, :autosave => true, :dependent => :destroy

        alias_method_chain :predecessor, :build

        # Expose columns from the predecessor
        self._predecessor_klass.columns.reject{|c| c.primary and not c.name.eql?("id") }.each do |att|
          if att.primary then
            if ( defined? params[:include_predecessor_id] and not params[:include_predecessor_id].nil? and params[:include_predecessor_id] == true) then
              define_method(predecessor_symbol.to_s.underscore + "_id") do
                predecessor.send(att.name)
              end
            end
            next
          end

          if att.name =~ /^heir_/ then
            define_method(predecessor_symbol.to_s.underscore + att.name) do
              predecessor.send(att.name)
            end
            next
          end

          define_method(att.name) do
            predecessor.send(att.name)
          end
          define_method("#{att.name}=") do |val|
            predecessor.send("#{att.name}=",val)
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
        before_update :touch_predecessor, :unless => lambda { predecessor.changed? }

        # Expose methods from predecessor
        self._predecessor_klass.get_heritage_exposed_methods.each do |method_symbol|
          define_method(method_symbol.to_s) do |*args|
            if args.length > 0
              predecessor.send(method_symbol.to_s, args.flatten)
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
          if self.changed?
            predecessor.touch
          end
        end
      end

    end
  end
end
