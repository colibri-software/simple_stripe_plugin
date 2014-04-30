require "simple_stripe_plugin/engine"
require "simple_stripe_plugin/javascript"
require "simple_stripe_plugin/form"

module SimpleStripePlugin
  class SimpleStripePlugin
    include Locomotive::Plugin

    before_page_render :set_config

    def self.default_plugin_id
      'stripe'
    end

    def self.rack_app
      Engine
    end

    def config_template_file
      File.join(File.dirname(__FILE__), 'simple_stripe_plugin', 'config.html')
    end

    def self.liquid_tags
      {
        javascript: JavaScript,
        form: Form
      }
    end
    def set_config
      mounted_rack_app.config = config
    end
  end
end
