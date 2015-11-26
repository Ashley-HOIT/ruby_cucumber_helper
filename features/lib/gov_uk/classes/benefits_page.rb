# modules group together classes, methods, and constants. A Key benefit is that it prevents name clashes.
module Gov_uk
  class Benefits_page

    # Explicitly included capybara as this is required to use the methods find/find_by..
    include Capybara::DSL

    # attr_reader provides the ability to read variables from the object that is created
    attr_reader :url

    def initialize
      @url = "#{config('host')}"+ Gov_uk::Config::Endpoints::BENEFITS_PAGE
    end

    def benefits_page_title
      find(:css, '#section > div > h1')
    end

  end
end
