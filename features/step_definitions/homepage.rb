# step definitions should not contain css selectors or element id's
# step definitions should be named after the page you are testing
# basic formula equals 'Action, assert Action has taken place'
# each new page tested equals a new class, this keeps css selectors or element id's in one place


Given(/^I am on the gov\.uk's home page$/) do
  @homepage = Gov_uk::Gov_uk_homepage.new
  visit(@homepage.url)
  expect(@homepage.homepage_title.text).to eq (Gov_uk::Config::Displayed_text::HOMEPAGE_TITLE)
end

When(/^I click on the benefits link$/) do
  benefits_link=@homepage.benefits_link
  benefits_link.click
end

Then(/^I am taken to the benefits page$/) do
  @benefits_page = Gov_uk::Benefits_page.new
  expect(@benefits_page.benefits_page_title.text).to eq (Gov_uk::Config::Displayed_text::BENEFITS_PAGE_TITLE)
end