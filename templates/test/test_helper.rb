require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
# Require support files
Dir[File.expand_path('../support/*.rb', __FILE__)].each {|file| require file}
 
require 'factory_girl'
require 'minitest/autorun'
require 'minitest/rails'
require 'minitest/rails/capybara'
 
begin; require 'turn/autorun'; rescue LoadError; end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end
 
class ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers
  include Capybara::RSpecMatchers
  include Capybara::DSL
  
  # include BoostrapMacros
end
