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
DatabaseCleaner.strategy = :transaction 

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  
  # Add more helper methods to be used by all tests here...
  include FactoryGirl::Syntax::Methods
  
  
  def self.prepare
   DatabaseCleaner.clean
    # Add code that needs to be executed before test suite start
  end
  prepare

  def setup
   # Add code that need to be executed before each test
  end

  def teardown
   # Add code that need to be executed after each test
  end
end
 
class ActionDispatch::IntegrationTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  include Capybara::DSL
end

# ActiveSupport::TestCase
# ActionController::TestCase
# ActionView::TestCase
# ActionMailer::TestCase
# ActionDispatch::TestCase 
