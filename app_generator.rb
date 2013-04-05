class AppBuilder < Rails::AppBuilder
  def initialize(generator)
    super(generator)

    @generate_after_bundler = []
    @master_url = "https://raw.github.com/smashingboxes/sb_app_generator/master"
  end

  def get_from_master_repo(file_path)
    get "#{@master_url}/templates/#{file_path}", file_path
    gsub_file file_path, /\{\{app_name\}\}/, "my_app"
  end

  # def rakefile
  #   template "Rakefile"
  # end

  def readme
    get_from_master_repo "README.markdown"
     #   copy_file "README.rdoc", "README.rdoc"
  end


  # def test
# #     empty_directory "features"
# #     empty_directory "steps"

# #     create_file "test/minitest_helper.rb", <<-RUBY
# # ENV["RAILS_ENV"] = "test"
# # require File.expand_path('../../config/environment', __FILE__)

# # require "minitest/autorun"
# # require "minitest/rails"
# # require "minitest/rails/capybara"

# # begin; require 'turn/autorun'; rescue LoadError; end

# # class ActiveSupport::TestCase
# #   include FactoryGirl::Syntax::Methods
# # end

# # class ActionDispatch::IntegrationTest
# #   include Rails.application.routes.url_helpers
# #   include Capybara::RSpecMatchers
# #   include Capybara::DSL
# # end
# # RUBY

# #     create_file "features/support/env.rb", <<-RUBY
# # ENV['RAILS_ENV'] = 'test'
# # require './config/environment'
# # require 'minitest/spec'
# # require 'database_cleaner'

# # DatabaseCleaner.strategy = :truncation

# # Spinach.hooks.before_scenario{ DatabaseCleaner.clean }

# # # Spinach.config.save_and_open_page_on_failure = true
# # RUBY

# #   create_file "Guardfile", <<-TEXT
# # guard 'minitest' do
# #   # with Minitest::Unit
# #   watch(%r|^test/(.*)\\/?test_(.*)\\.rb|)
# #   watch(%r|^lib/(.*)([^/]+)\\.rb|)     { |m| "test/\#{m[1]}test_\#{m[2]}.rb" }
# #   watch(%r|^test/test_helper\\.rb|)    { "test" }
 
# #   # with Minitest::Spec
# #   # watch(%r|^spec/(.*)_spec\\.rb|)
# #   # watch(%r|^lib/(.*)([^/]+)\\.rb|)     { |m| "spec/\#{m[1]}\#{m[2]}_spec.rb" }
# #   # watch(%r|^spec/spec_helper\\.rb|)    { "spec" }
 
# #   watch(%r|^app/controllers/(.*)\\.rb|) { |m| "test/controllers/\#{m[1]}_test.rb" }
# #   watch(%r|^app/helpers/(.*)\\.rb|)     { |m| "test/helpers/\#{m[1]}_test.rb" }
# #   watch(%r|^app/models/(.*)\\.rb|)      { |m| "test/unit/\#{m[1]}_test.rb" }  
# # end
# # guard 'spinach' do
# #   watch(%r|^features/(.*)\\.feature|)
# #   watch(%r|^features/steps/(.*)([^/]+)\\.rb|) do |m|
# #     "features/\#{m[1]}\#{m[2]}.feature"
# #   end
# # end
# # TEXT
  # end
#   # def test
#   #   empty_directory_with_keep_file 'test/fixtures'
#   #   empty_directory_with_keep_file 'test/controllers'
#   #   empty_directory_with_keep_file 'test/mailers'
#   #   empty_directory_with_keep_file 'test/models'
#   #   empty_directory_with_keep_file 'test/helpers'
#   #   empty_directory_with_keep_file 'test/integration'

#   #   template 'test/test_helper.rb'
#   # end

  def gemfile
    get_from_master_repo "Gemfile"
  end  


#   # def configru
#   #   template "config.ru"
#   # end

  def gitignore
    git :init
    get_from_master_repo ".gitignore"
    #   copy_file "gitignore", ".gitignore"
  end


  # def app
  #   directory 'app'

  #   keep_file  'app/mailers'
  #   keep_file  'app/models'

  #   keep_file  'app/controllers/concerns'
  #   keep_file  'app/models/concerns'
  # end

  # def bin
  #   directory "bin" do |content|
  #     "#{shebang}\n" + content
  #   end
  #   chmod "bin", 0755, verbose: false
  # end

  # def config
  #   empty_directory "config"

  #   inside "config" do
  #     template "routes.rb"
  #     template "application.rb"
  #     template "environment.rb"

  #     directory "environments"
  #     directory "initializers"
  #     directory "locales"
  #   end
  # end

  def database_yml
    get_from_master_repo "config/database.yml"
    run "cp config/database.yml config/example_database.yml"
    #   template "config/databases/#{options[:database]}.yml", "config/database.yml"
  end


  # def db
  #   directory "db"
  # end

  # def lib
  #   empty_directory 'lib'
  #   empty_directory_with_keep_file 'lib/tasks'
  #   empty_directory_with_keep_file 'lib/assets'
  # end

  # def log
  #   empty_directory_with_keep_file 'log'
  # end

  # def public_directory
  #   directory "public", "public", recursive: false
  # end

  # def tmp
  #   empty_directory "tmp/cache"
  #   empty_directory "tmp/cache/assets"
  # end

  # def vendor
  #   vendor_javascripts
  #   vendor_stylesheets
  # end

  # def vendor_javascripts
  #   empty_directory_with_keep_file 'vendor/assets/javascripts'
  # end

  # def vendor_stylesheets
  #   empty_directory_with_keep_file 'vendor/assets/stylesheets'
  # end

  
  def leftovers
    get_from_master_repo "Procfile"
    get_from_master_repo "config/initializers/strong_parameters.rb"

    gsub_file "config/application.rb", /(\s*config\.active_record\.whitelist_attributes\ =\ )true/, '\1false'

    bundle_command('install')

    db_name = ask("What is your database name").underscore
    db_username = ask("Database Username").underscore
    db_password = ask("Database Password").underscore
    gsub_file "config/database.yml", /\{\{db_name\}\}/, db_name
    gsub_file "config/database.yml", /\{\{db_user\}\}/, db_username
    gsub_file "config/database.yml", /\{\{db_password\}\}/, db_password
    rake("db:create:all")

    generate 'simple_form:install --bootstrap'

    if yes? "Do you want to generate a root controller?"
      name = ask("What should it be called?").underscore
      generate :controller, "#{name} index"
      route "root to: '#{name}\#index'"
      remove_file "public/index.html"
    end

    git add: ".", commit: "-m 'initial commit'"
  end
end
