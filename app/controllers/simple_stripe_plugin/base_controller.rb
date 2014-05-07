require'stripe'

module SimpleStripePlugin
  class BaseController < ActionController::Base
    before_filter :set_current_site

    def current_site
      Thread.current[:site]
    end

    private

    def fetch_site
      if Locomotive.config.multi_sites?
        @current_site ||= Locomotive::Site.match_domain(request.host).first
      else
        @current_site ||= Locomotive::Site.first
      end
    end

    def set_current_site
      Thread.current[:site] = fetch_site
    end
  end
end
