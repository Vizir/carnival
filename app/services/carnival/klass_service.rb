module Carnival
  class KlassService

    def initialize(klass)
      @klass = klass
    end

    def relation? sym
      !get_association(sym).nil?
    end

    def relation_type sym
      return nil if !relation?(sym)
      association = get_association(sym)
      return association.macro if association.macro != :has_many
      return :many_to_many if many_to_many_relation? association
      return :has_many
    end

    def method_missing(method, *args)
      if method.to_s.index(/^is_a_(.*)_relation\?$/)
        result =  method.to_s.match(/^is_a_(.*)_relation\?$/)
        relation = result[1]
        return relation_type(args[0]) == relation.to_sym
      end
    end

    def related_class_file_name sym
      return nil if !relation?(sym)
      get_related_class(sym).name.pluralize.underscore
    end

    def related_class sym
      return nil if !relation?(sym)
      get_related_class(sym).classify
    end

    def extract_namespace
      namespace = ""
      arr = @klass.to_s.split("::")
      namespace = arr[0] if arr.size > 1
      namespace
    end

    def is_namespaced?
      @klass.to_s.split("::").size > 1
    end

    def table_name
      @klass.table_name 
    end

    def klass
      @klass 
    end

private

    def get_association sym
      @klass.reflect_on_association(sym)
    end

    def get_related_class sym
      get_association(sym).klass
    end

    def many_to_many_relation? association
      return true if association.macro == :has_and_belongs_to_many
      return false if association.macro == :has_many 
      return true if association.options[:through].present?
      return false
    end

  end
end
