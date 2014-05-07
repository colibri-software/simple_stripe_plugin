require 'erb'

module SimpleStripePlugin
  class JavaScript < ::Liquid::Tag

    def initialize(tag_name, markup, tokens, context)
      @options = {
        public_key: nil,
        form_id: 'payment-form',
        errors_id: 'payment-errors',
        success_message: 'Payment Successful!',
      }
      markup.scan(::Liquid::TagAttributes) { |key, value| @options[key.to_sym] = value.gsub(/"|'/, '') }
      super
    end

    def render(context)
      @options[:public_key] = Engine.config[:stripe_public]
      ERB.new(File.read(File.join(File.dirname(__FILE__), 'javascript.erb'))).result binding
    end
  end
end

