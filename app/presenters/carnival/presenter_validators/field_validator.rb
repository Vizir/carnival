module Carnival::PresenterValidators
  class FieldValidator
    EDIT_ACTIONS = [:new, :edit]
    SHOW_ACTIONS = [:index, :show]

    def initialize(presenter)
      @presenter = presenter
    end


    def validates
      fields.each do |field|
        validates_one_to_one_associations(field)
      end
    end

    def validates_one_to_one_associations(field)
      if field.specified_association?
        check_field_invalid_actions(field, EDIT_ACTIONS)
      elsif @presenter.is_one_to_one_relation?(field)
        check_field_invalid_actions(field, SHOW_ACTIONS)
      end
    end

    private
    def check_field_invalid_actions(field, actions)
      return if field.actions.nil?
      intersection = actions & field.actions
      if intersection.size > 0
        error = I18n.t("carnival.errors.invalid_field", actions: intersection, field: field.name, presenter: @presenter.presenter_name)
        raise ArgumentError.new(error)
      end
    end

    def fields
      @presenter.fields.values
    end
  end
end
