# modules group together classes, methods, and constants. A Key benefit is that it prevents name clashes.
module Gov_uk
  # these are constants and should be used when data values are fixed
  # constants can be used by using the formula moduleName::moduleName::moduleName::constant
  # i.e Gov_uk::Config::Endpoints::HOMEPAGE
  module Config

    module Endpoints
      HOMEPAGE = 'gov.uk/'
      BENEFITS_PAGE = 'gov.uk/browse/benefits'
    end

    module Displayed_text
      HOMEPAGE_TITLE = 'Welcome to GOV.UK'
      BENEFITS_PAGE_TITLE = 'Benefits'
    end

  end
end
