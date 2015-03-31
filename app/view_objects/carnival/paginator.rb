module Carnival
  class Paginator
    def initialize(current_page, last_page, max_fast_pages = 5)
      @current_page = current_page
      @last_page = last_page >= 1 ? last_page : 1
      @max_fast_pages = max_fast_pages
    end

    def fast_pages_links_indexes
      fast_page_links = []
      first_index = -(@max_fast_pages / 2)
      while fast_page_links.size < @max_fast_pages
        fast_page = @current_page + first_index
        break if fast_page > @last_page
        fast_page_links << fast_page if fast_page > 0
        first_index += 1
      end
      fast_page_links
    end

    def fast_pages_links_html
      fast_pages_links_indexes.map do |page|
        { label: page, css_class: get_css_class(page), js_function: get_js_function(page) }
      end
    end

    def get_js_function(page)
      "javascript:Carnival.goToPage(#{page})"
    end

    def get_css_class(page)
      if page == @current_page
        'carnival-selected-page-button'
      else
        'carnival-page-button'
      end
    end

    def previous_page
      if @current_page - 1 < 1
        @current_page
      else
        @current_page - 1
      end
    end

    def next_page
      if @current_page + 1 > @last_page
        @current_page
      else
        @current_page + 1
      end
    end

    def pages
      htmls = []
      htmls << { label: ('paginate_first'), js_function: get_js_function(1) }
      htmls << { :label => ('paginate_previous'), js_function: get_js_function(previous_page) }
      htmls = htmls + fast_pages_links_html
      htmls << { label: ('paginate_next'), js_function: get_js_function(next_page) }
      htmls << { label: ('paginate_last'), js_function: get_js_function(@last_page) }
    end
  end
end
