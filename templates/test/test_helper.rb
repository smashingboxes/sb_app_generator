# require "codeclimate-test-reporter"
# CodeClimate::TestReporter.start

require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help' 
require 'factory_girl'
require 'minitest/autorun'
require 'minitest/rails'
require 'minitest/rails/capybara'
require 'database_cleaner'
require 'minitest-metadata'
require 'capybara-screenshot/minitest'

# Support files
Dir[File.expand_path('../support/*.rb', __FILE__)].each {|file| require file}

# Database cleaner
DatabaseCleaner.strategy = :transaction 

# Coloring 
require "minitest/reporters"
Minitest::Reporters.use!

####
# All tests
class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  include FactoryGirl::Syntax::Methods

  def setup
    DatabaseCleaner.clean
    # Add code that needs to be executed before test suite start
  end
  def teardown
    DatabaseCleaner.clean
  end
end

 ###
 # Integration Tests
class ActionDispatch::IntegrationTest < ActiveSupport::TestCase
  include Rails.application.routes.url_helpers
  include Capybara::DSL
  include MiniTest::Metadata
  include Warden::Test::Helpers

  self.use_transactional_fixtures = false

  def setup
    Warden.test_mode!
    super
  end

  def teardown
    Warden.test_reset!
    super
  end

  before do
    DatabaseCleaner.clean_with :truncation
    if metadata[:js] == true
      Capybara.current_driver = :webkit
    end
  end

  after do
    Capybara.current_driver = Capybara.default_driver
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

