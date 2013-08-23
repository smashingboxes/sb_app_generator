require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help' 
require 'factory_girl'
require 'minitest/autorun'
require 'minitest/rails'
require 'minitest/rails/capybara'
require "database_cleaner"

# Support files
Dir[File.expand_path('../support/*.rb', __FILE__)].each {|file| require file}
# Database cleaner
DatabaseCleaner.strategy = :transaction 
# Coloring 
begin; require 'turn/autorun'; rescue LoadError; end

####
# All tests
class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  include FactoryGirl::Syntax::Methods

  def self.prepare
   DatabaseCleaner.clean
    # Add code that needs to be executed before test suite start
  end
  prepare
end
 
 ###
 # Integration Tests
class ActionDispatch::IntegrationTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  include Capybara::DSL

  include Warden::Test::Helpers
  Warden.test_mode!

  def setup
   # Add code that need to be executed before each test
  end
  def teardown
    Warden.test_reset! 
  end
end

###
# Controller Test
class ActionController::TestCase < ActiveSupport::TestCase
  include Devise::TestHelpers
end

# ActionView::TestCase
# ActionMailer::TestCase
# ActionDispatch::TestCase 

