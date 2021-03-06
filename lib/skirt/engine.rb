module Skirt
  class Engine < ::Rails::Engine
    isolate_namespace Skirt

    initializer 'skirt.action_view_helpers' do
      ActiveSupport.on_load :action_view do
        include Skirt::ApplicationHelper
      end
    end

    initializer "skirt.assets.precompile" do |app|
      app.config.assets.precompile += %w(application.js)
    end


    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
  end
end
