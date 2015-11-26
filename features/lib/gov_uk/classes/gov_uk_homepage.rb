# modules group together classes, methods, and constants. A Key benefit is that it prevents name clashes.
module Gov_uk
  class Gov_uk_homepage

    # Explicitly included capybara as this is required to use the methods find/find_by..
    include Capybara::DSL

    # attr_reader provides the ability to read variables from the object that is created
    attr_reader :url

    def initialize
      @url = "#{config('host')}"+ Gov_uk::Config::Endpoints::HOMEPAGE
    end

    def homepage_title
      find(:css, '#content > header > div > div > div > div.welcome-text > div > h1')
    end

    def benefits_link
     find(:css, '#services-and-information > div > div.categories-lists > ol:nth-child(1) > li:nth-child(1) > h3 > a')
    end
  end
end
