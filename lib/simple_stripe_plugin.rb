require "simple_stripe_plugin/engine"
require "simple_stripe_plugin/javascript"
require "simple_stripe_plugin/form"
require "simple_stripe_plugin/block_form"
require "simple_stripe_plugin/fields"

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
        form: Form,
        fields: Fields,
        form_block: BlockForm
      }
    end
    def set_config
      mounted_rack_app.config = config
    end
  end
end
