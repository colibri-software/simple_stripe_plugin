require 'simple_stripe_plugin/base_controller'

module SimpleStripePlugin
  class StripeController < BaseController
    def charge
      config = Engine.config
      Stripe.api_key = config[:stripe_secret]
      @response = {}

      # Get the transaction details submitted by the form
      type = params[:payment_type] || 'stripe'
      amount = (params[:amount].to_f * 100).to_i
      name = params[:name]
      number = params[:id_number]
      if name && number
        description = name + " for " + number
      elsif name && !number
        description = name
      elsif !name && number
        description = number
      else
        description = ""
      end
      token = params[:stripeToken] if type == "stripe"

      #Create a model entry if one was passed in
      payment_slug = config[:payment_model]
      payment_model = current_site.content_types.where(slug: payment_slug).first if payment_slug
      model_slug = params[:model_slug]
      model = current_site.content_types.where(slug: model_slug).first if model_slug
      entry = nil
      create_model = payment_slug && payment_model && model_slug && model && has_relation?(model, payment_model)

      if create_model
        entry = model.entries.safe_create(params[:entry] || params[:content])
        @response[:model] = true
      else
        if model_slug
          unless model
            @response[:model] = {error: {message: "No model with slug #{model_slug}."}}
          end
          unless has_relation?(model, payment_model)
            @response[:model] = {error: {message: "Model does not accept submissions."}}
          end
          @response
        end
      end

      if (create_model && entry.persisted?) || (!create_model && payment_model)
        # Charge the card
        begin
          if type == "stripe"
            charge = Stripe::Charge.create(
              :amount => amount, # in cents
              :currency => "cad",
              :card => token,
              :description => description,
            )
          else
            charge = nil
          end
          #create payment entry
          if payment_slug && payment_model
            attrs = {}
            attrs[config[:stripe_id_field_name]] = charge.id if charge
            attrs[config[:stripe_name_field_name]] = name
            attrs[config[:stripe_number_field_name]] = number
            attrs[config[:stripe_amount_field_name]] = amount.to_f / 100
            attrs[config[:payment_type_field_name]] = type

            payment_entry = payment_model.entries.safe_create(attrs)
            payment_entry.send("#{has_relation?(payment_model, model)}=".to_sym, entry) if entry
            unless payment_entry.persisted? && payment_entry.save
              @response[:model] = {error: {message: message(payment_entry)}}
            end

          end

          @response[:charge] = true
        rescue Stripe::CardError => e
          #Deal With Errors
          body = e.json_body
          err  = body[:error]
          entry.destroy if entry
          @response[:charge] = {error: {message: err[:message]}}

        end
      else
        if create_model
          @response[:model] = {error: {message: message(entry)}}
        elsif !payment_model
          @response[:model] = {error: {message: "No payment model."}}
        end
      end
      render json: @response
    end
    private
    def has_relation?(a, b)
      if a && b
        relations = [
          "belongs_to",
          "has_many",
          "many_to_many"
        ]
        id = b.id
        a.entries_custom_fields.each do |field|
          if relations.include?(field.type) && field.class_name = "Locomotive::ContentEntry#{id}"
            return field.name
          end
        end
      end
      false
    end
    def message(entry)
      message = ""
      entry.errors.each  do |f,m|
        unless f.to_s =~ /^_/
          message += "#{f.to_s.titleize} #{m}"
        end
      end
      message
    end
  end
end
