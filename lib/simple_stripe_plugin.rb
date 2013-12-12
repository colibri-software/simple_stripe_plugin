require "simple_stripe_plugin/engine"

module SimpleStripePlugin
  class SimpleStripePlugin
    include Locomotive::Plugin

    def self.default_plugin_id
      'stripe'
    end

    def self.rack_app
      Engine
    end

    def config_template_file
      File.join(File.dirname(__FILE__), 'simple_stripe_plugin', 'config.html')
    end

  end
end
