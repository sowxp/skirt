$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "skirt/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "skirt"
  s.version     = Skirt::VERSION
  s.authors     = ["sowxp"]
  s.email       = [""]
  s.homepage    = "http://sowxp.co.jp"
  s.summary     = "amazon payments"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  #s.test_files = Dir["test/**/*"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 5.1"
  s.add_dependency "pay_with_amazon"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "slim"
  s.add_development_dependency "slim-rails"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "turnip"
  s.add_development_dependency "gherkin"
  s.add_development_dependency "capybara"
  s.add_development_dependency "poltergeist"
  s.add_development_dependency "selenium-webdriver"

end
