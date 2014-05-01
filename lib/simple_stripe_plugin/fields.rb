require 'erb'

module SimpleStripePlugin
  class Fields < ::Liquid::Tag

    def initialize(tag_name, markup, tokens, context)
      @options = {
        name_label: "Name",
        id_number_label: "Identification Number",
        amount_label: "Amount",
        number_label: "Card Number",
        exp_label: "Experation Date",
        cvc_label: "CVC",
        submit_label: "Submit Payment"
      }
      markup.scan(::Liquid::TagAttributes) { |key, value| @options[key.to_sym] = value.gsub(/"|'/, '') }
      super
    end

    def render(context)
      ERB.new(File.read(File.join(File.dirname(__FILE__), 'fields.erb'))).result binding
    end
  end
end

