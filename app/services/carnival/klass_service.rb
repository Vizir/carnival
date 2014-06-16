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
    end

    def relation_type sym
       get_association(sym).macro 
    end

    def method_missing(method, *args)
      if method.to_s.index(/^is_a_(.*)_relation\?$/)
        result =  method.to_s.match(/^is_a_(.*)_relation\?$/)
        relation = result[1]
        return get_association(args[0]).macro == relation.to_sym
      end
    end

    def related_class_file_name sym
      return nil if !relation?(sym)
      if is_namespaced? and !@klass.reflect_on_association(sym).klass.name.pluralize.underscore.include?("/")
        return "#{extract_namespace.downcase}/#{get_related_class(sym).name.pluralize.underscore}"
      else
        return get_related_class(sym).name.pluralize.underscore
      end
    end

    def extract_namespace
      namespace = ""
      arr = @klass.to_s.split("::")
      namespace = arr[0] if arr.size > 1
      namespace
    end

    def is_namespaced?
      @klass.to_s.split("::").size > 0
    end

private

    def get_association sym
      @klass.reflect_on_association(sym)
    end

    def get_related_class sym
      get_association(sym).klass
    end

  end
end
