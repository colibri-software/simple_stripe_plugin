SimpleStripePlugin::Engine.routes.draw do
  post '/charge' => "stripe#charge", as: 'charge'
end
