require 'rails_helper'

require 'turnip'           
require 'turnip/capybara'  
require 'turnip/rspec'        
require 'capybara'         
require 'capybara/poltergeist'


Dir.glob("spec/acceptance/steps/**/*_steps.rb") { |f| load f, true }   

Capybara.register_driver :pc do |app|

  Capybara::RackTest::Driver.new(app,
    :headers => {'HTTP_USER_AGENT' => 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)'})
end

Capybara.register_driver :poltergeist do |app|
  driver = Capybara::Poltergeist::Driver.new(app, { js_errors: false,
                                           cookies: true,
                                           default_max_wait_time: 30, 
                                           timeout: 100,
                                           debug: false,
                                           phantomjs_options: ['--debug=no', '--load-images=yes', '--ignore-ssl-errors=true', '--ssl-protocol=any', '--local-to-remote-url-access=yes', '--ssl-protocol=TLSv1']
                                         })  

  # amazonは正しいUAじゃないと受け付けない
  driver.headers = {'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:36.0) Gecko/20100101 Firefox/36.0 WebKit'}
  driver
end 


Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.configure do |config|
  config.default_driver = :selenium
  config.javascript_driver = :selenium

  # config.default_driver = :poltergeist
  # config.javascript_driver = :poltergeist

  config.ignore_hidden_elements = true
  config.default_max_wait_time = 30
end  

Capybara.default_host = "sowxp-gift-poltergeist.dev"

Capybara.server_port = 8443
Capybara.app_host = "https://#{Capybara.default_host}:#{Capybara.server_port}"


# Capybara.app_host = "https://#{Capybara.default_host}"
