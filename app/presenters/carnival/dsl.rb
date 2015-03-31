module Carnival
  module Dsl
    extend ActiveSupport::Concern

    included do
      [:index_as, :actions, :batch_actions, :items_per_page,
       :model_names, :fields, :scopes, :forms]
        .each do |variable_name|
        class_variable_set("@@#{variable_name}", {})
      end
    end

    module ClassMethods
      def index_as(type)
        class_variable_get('@@index_as')[presenter_class_name] = type
      end

      def action(name, params = {})
        class_variable_get('@@actions')[presenter_class_name] ||= {}
        class_variable_get('@@actions')[presenter_class_name][name] = Carnival::Action.new(name, params)
      end

      def batch_action(name, params = {})
        class_variable_get('@@batch_actions')[presenter_class_name] ||= {}
        class_variable_get('@@batch_actions')[presenter_class_name][name] = Carnival::BatchAction.new(self.new({}), name, params)
      end

      def items_per_page(per_page)
        class_variable_get('@@items_per_page')[presenter_class_name] ||= {}
        class_variable_get('@@items_per_page')[presenter_class_name][:items_per_page] = per_page
      end

      def scope(name, params = {})
        instantiate_element(class_variable_get('@@scopes'), Carnival::Scope, name.to_sym, params)
      end

      def field(name, params = {})
        instantiate_element(class_variable_get('@@fields'), Carnival::Field, name.to_sym, params)
      end

      def form(action, params = {})
        instantiate_element(class_variable_get('@@forms'), Carnival::Form, name.to_sym, params)
      end

      def model_name(name)
        class_variable_get('@@model_names')[presenter_class_name] = name
      end

      def instantiate_element(container, klass, name, params)
        container[presenter_class_name] ||= {}
        container[presenter_class_name][name] = klass.new(name, params)
      end
    end
  end
end
