class HeaderPaginator < ApplicationService
  def initialize(page, url)
    @page = page
    @url = url
  end

  def call
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

  private

    def first_page(last)
      last_link = "<#{@url}?page=#{last}>; rel=\"last\""
      next_link = "<#{@url}?page=2>; rel=\"next\""
      "#{last_link}, #{next_link}"
    end

    def middle_page(prev, next_page, last)
      first_link = "<#{@url}?page=1>; rel=\"first\""
      prev_link = "<#{@url}?page=#{prev}>; rel=\"prev\""
      last_link = "<#{@url}?page=#{last}>; rel=\"last\""
      next_link = "<#{@url}?page=#{next_page}>; rel=\"next\""
      "#{first_link}, #{prev_link}, #{last_link}, #{next_link}"
    end

    def last_page(prev)
      first_link = "<#{@url}?page=1>; rel=\"first\""
      prev_link = "<#{@url}?page=#{prev}>; rel=\"prev\""
      "#{first_link}, #{prev_link}"
    end
end