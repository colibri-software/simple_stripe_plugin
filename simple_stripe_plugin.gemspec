lib = File.expand_path("../lib", __FILE__)
$:.unshift lib unless $:.include?(lib)

# Maintain your gem's version:
require "simple_stripe_plugin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simple_stripe_plugin"
  s.version     = SimpleStripePlugin::VERSION
  s.authors     = ["Charlie Greene"]
  s.email       = ["charlie@colibri-software.com"]
  s.homepage    = "https://www.colibri-software.com"
  s.summary     = "Stripe plugin to perform a charge"
  s.description = "Stripe plugin to perform a charge"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.16"
  s.add_dependency "stripe"
end
