module SimpleStripePlugin
  class Engine < ::Rails::Engine
    isolate_namespace SimpleStripePlugin
    def self.config=(hash)
      @config_hash = hash
    end
    def self.config
      @config_hash ||= {}
    end
  end
end
