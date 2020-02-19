# frozen_string_literal: true

# Custom Helpers
module ApplicationHelper
  # Returns the full title per page
  def full_title(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App'
    return page_title + ' | ' + base_title unless page_title.empty?

    base_title
  end
end
