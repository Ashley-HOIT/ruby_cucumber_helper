require 'rspec/expectations'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara/dsl'
require 'selenium-webdriver'
require 'faraday_middleware'
require 'require_all'
require 'time'
require 'date'
require 'csv'
require 'json'
require 'webrick'
require 'webrick/httpproxy'
# require 'appium_capybara'


require_all 'features/lib/gov_uk/classes'
require_all 'features/lib/env/classes'


# loads the config file. The default config file is config.yml.
# alternative config files can be used by setting the CONFIG_FILE variable to 'features/support/config-dev.yml' for example
config_file = ENV['CONFIG_FILE'] || "#{File.dirname(__FILE__)}/config.yml"
$app_config = YAML.load_file(config_file)

def config(key)
  $app_config[key]
end


if ENV['PROXY']
  puts "\n ####### RUNNING PROXY #######"
  @proxy_server=Env::Env_setup.new
  @proxy_server.create_proxy
  @proxy_pid = @proxy_server.start_proxy
  Process.detach(@proxy_pid)
  @proxy_server.exists?

  at_exit do
    puts "\n ####### Killing proxy apps #######"
    @proxy_server.kill_proxy_app
  end

  if ENV['BROWSER']=='firefox'
    proxy = "#{config('proxy_host')}"+":#{@proxy_server.port_num}"
  elsif ENV['BROWSER']=='chrome'
    PROXY = "#{config('proxy_host')}"+":#{@proxy_server.port_num}"
    proxy = Selenium::WebDriver::Proxy.new(:http => PROXY, :ftp => PROXY, :ssl => PROXY)
  elsif !ENV['BROWSER']
    proxy = "#{config('proxy_host')}"+":#{@proxy_server.port_num}"
  end
else
  proxy = nil

end


if ENV['BROWSER']=='firefox'

  puts "\n ####### RUNNING IN BROWSER FIREFOX #######"
  Capybara.default_driver = :firefox
  Capybara.register_driver :firefox do |app|
    # profile options = http://preferential.mozdev.org/preferences.html
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile.proxy = Selenium::WebDriver::Proxy.new(:http => proxy, :ftp => proxy, :ssl => proxy)
    profile['browser.download.dir'] = File.expand_path("temp")
    profile['browser.download.folderList'] = 2
    profile['browser.helperApps.neverAsk.saveToDisk'] = "application/zip"
    Capybara::Selenium::Driver.new(app, :browser => :firefox, :profile => profile)

  end

elsif ENV['BROWSER']=='chrome'

  puts "\n ####### RUNNING IN BROWSER CHROME #######"
  Capybara.default_driver = :chrome
  Capybara.register_driver :chrome do |app|
    # profile options = http://src.chromium.org/svn/trunk/src/chrome/common/pref_names.cc
    prefs = {
        :download => {
            :prompt_for_download => false,
            :default_directory => File.expand_path("temp")
        }
    }
    caps = Selenium::WebDriver::Remote::Capabilities.ie(:proxy => proxy)
    Capybara::Selenium::Driver.new(app, :browser => :chrome, :prefs => prefs, :desired_capabilities => caps)

  end

elsif ENV['BROWSER'] == 'appium'
  capabilities = {

      :deviceName => 'iPhone Simulator',
      :browserName => 'iOS',
      :platformVersion => '9.2',
      :platformName => 'iOS',
      :app => 'safari'
  }
      url = "http://127.0.0.1:4723/wd/hub"


  Capybara.register_driver(:appium) do |app|
    appium_lib_options = {
        server_url: url
    }
    all_options = {
        appium_lib: appium_lib_options,
        caps: capabilities
    }
    Appium::Capybara::Driver.new app, all_options
  end

  Capybara.default_driver = :appium

else
  # DEFAULT: headless tests with poltergeist/phantomjs
  Capybara.default_driver = :poltergeist
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, :phantomjs_options => ["--proxy='#{proxy}'", "--ignore-ssl-errors=true", "--load-images=false"])
  end
  Capybara.javascript_driver = :poltergeist
end

# default page element selector
Capybara.default_selector = :css
# default timeout period affects all browsers
Capybara.default_max_wait_time = 5