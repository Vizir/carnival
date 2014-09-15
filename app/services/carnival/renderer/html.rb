module Carnival
  module Renderer
    class Html
      attr_accessor :presenter, :query_form, :query_service
      def initialize presenter, params
        @presenter = presenter
        @query_form = Carnival::QueryFormCreator.create(@presenter, params)
        @query_service = Carnival::QueryService.new(@model, @presenter, @query_form)
      end



    end
  end
end
