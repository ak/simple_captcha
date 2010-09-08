# This is only loaded by Rails 3.0.0+
Rails.application.routes.draw do
  match '/simple_captcha/:action', :to => 'simple_captcha', :as => :simple_captcha
end
# Rails < 3.0.0 one needs to manually add this to RAILS_ROOT/config/routes.rb :
=begin
ActionController::Routing::Routes.draw do |map|
  map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
end
=end