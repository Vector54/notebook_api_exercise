class JsonPaginator < ApplicationService
  def initialize(page, url)
    @page = page
    @page_size = page.size
    @url = url
  end

  def call
    self_link = {self: @url + "?page[number]=#{@page.current_page}&page[size]=#{@page_size}"}
    self_link.merge(condition_result)
  end

  private

    def condition_result
      current_page = @page.current_page
      last_page = @page.total_pages
      if current_page == 1
        first_page(last_page)
      elsif current_page == last_page
        last_page(@page.prev_page)
      else
        middle_page(@page.prev_page, @page.next_page, last_page)
      end
    end

    def first_page(last)
      {
        next: "2",
        last: last
      }.map {|k, v| [k, url_writer(v)] }.to_h 
    end

    def last_page(prev)
      {
        first: "1",
        prev: prev
      }.map {|k, v| [k, url_writer(v)] }.to_h  
    end

    def middle_page(prev, nxt, last)
      {
        first: "1",
        prev: prev,
        next: nxt,
        last: last
      }.map {|k, v| [k, url_writer(v)] }.to_h 
    end

    def url_writer(number)
      @url + "?page[number]=" + number.to_s + "&page[size]=#{@page_size}"
    end
end