module Carnival
  class Paginator

    def initialize(actual_page, last_page, max_fast_pages = 5)
      @actual_page = actual_page 
      @last_page = last_page >= 1 ? last_page : 1
      @max_fast_pages = max_fast_pages
    end

    def fast_pages_links_indexes
      fast_page_links = []
      first_index = -(@max_fast_pages/2)
      while fast_page_links.size < @max_fast_pages do
        fast_page = @actual_page + first_index
        break if fast_page > @last_page
        fast_page_links << fast_page if fast_page > 0
        first_index = first_index + 1
      end
      fast_page_links
    end
    
    def fast_pages_links_html
      htmls = []
      fast_pages_links_indexes.each do |page| 
        htmls << {:label => page, :js_function => "javascript:Carnival.updateIndexFormAndSubmit('page', #{page});"}
      end
      htmls
    end

    def previous_page
      return @actual_page if @actual_page - 1 < 1 
      @actual_page - 1
    end

    def next_page
      return @actual_page if @actual_page + 1 > @last_page 
      @actual_page + 1
    end

    def pages
      htmls = [] 
      htmls << {:label => ('paginate_first'), :js_function => "javascript:Carnival.updateIndexFormAndSubmit('page', 1);"}
      htmls << {:label => ('paginate_previous'), :js_function => "javascript:Carnival.updateIndexFormAndSubmit('page', #{previous_page});"}
      htmls = htmls + fast_pages_links_html
      htmls << {:label => ('paginate_next'), :js_function => "javascript:Carnival.updateIndexFormAndSubmit('page', #{next_page});"}
      htmls << {:label => ('paginate_last'), :js_function => "javascript:Carnival.updateIndexFormAndSubmit('page', #{@last_page});"}
    end

  end
end
