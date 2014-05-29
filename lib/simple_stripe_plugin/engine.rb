module SimpleStripePlugin
  class Engine < ::Rails::Engine
    isolate_namespace SimpleStripePlugin
    def self.config=(hash)
      @config_hash = ConfigObject.new(hash)
    end
    def self.config
      @config_hash ||= ConfigObject.new
      @config_hash
    end
  end
  class ConfigObject < Hash
    def initialize(hash = {})
      defaults = {
        payment_model: 'payments',
        allow_offline: false,
        stripe_id_field_name: 'stripe_payment_id',
        stripe_name_field_name: 'name',
        stripe_number_field_name: 'id_number',
        stripe_amount_field_name: 'amount',
        payment_type_field_name: 'payment_type',
      }
      merge!(defaults)
      hash.select! {|k,v| v && (v.class != String || !v.empty?)}
      merge!(hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo})
    end
  end
end
