require 'erb'

module SimpleStripePlugin
  class BlockForm < ::Liquid::Block

    def initialize(tag_name, markup, tokens, context)
      @options = {
        submit_model: nil
      }
      markup.scan(::Liquid::TagAttributes) { |key, value| @options[key.to_sym] = value.gsub(/"|'/, '') }
      super
    end

    def render(context)
      @options[:submit_model] = context[@options[:submit_model]]
      form_start = ERB.new(File.read(File.join(File.dirname(__FILE__), 'form_start.erb'))).result binding
      fields = render_all(@nodelist, context)
      form_end = ERB.new(File.read(File.join(File.dirname(__FILE__), 'form_end.erb'))).result binding
      return form_start + fields + form_end
    end
  end
end

