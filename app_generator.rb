# https://github.com/rails/rails/blob/v3.2.13/railties/lib/rails/generators/rails/app/app_generator.rb

class AppBuilder < Rails::AppBuilder
  def initialize(generator)
    super(generator)

    @master_url = "https://raw.github.com/smashingboxes/sb_app_generator/master"
  end

  def get_from_master_repo(file_path)
    get "#{@master_url}/templates/#{file_path}", file_path
  end

  def readme
    get_from_master_repo "README.markdown"
  end

  def test
    empty_directory_with_gitkeep 'test/factories'
    empty_directory_with_gitkeep 'test/controllers'
    empty_directory_with_gitkeep 'test/mailers'
    empty_directory_with_gitkeep 'test/models'
    empty_directory_with_gitkeep 'test/helpers'
    empty_directory_with_gitkeep 'test/integration'

    empty_directory 'test/support'
    get_from_master_repo 'test/support/bootstrap_macros.rb'

    get_from_master_repo 'test/test_helper.rb'

    get_from_master_repo 'Guardfile'
  end

  def gemfile
    get_from_master_repo "Gemfile"
  end  

  def gitignore
    git :init
    get_from_master_repo ".gitignore"
  end

  def database_yml
    get_from_master_repo "config/database.yml"
    run "cp config/database.yml config/example_database.yml"
  end
  
  def leftovers
    app_name = ask("What is your application name? ").underscore
    server_ip = ask("What is the IP of your production server (leave empty if you don't know it yet)? ")
    db_username = ask("Database Username: ").underscore
    db_password = ask("Database Password: ").underscore

    get_from_master_repo "Procfile"

    # Strong parameters
    get_from_master_repo "config/initializers/strong_parameters.rb"
    gsub_file "config/application.rb", /(\s*config\.active_record\.whitelist_attributes\ =\ )true/, '\1false'

    # Capistrano
    empty_directory_with_gitkeep "config/recipes/templates"
    get_from_master_repo "config/recipes/base.rb"
    get_from_master_repo "config/recipes/check.rb"
    get_from_master_repo "config/recipes/dragonfly.rb"
    get_from_master_repo "config/recipes/elasticsearch.rb"
    get_from_master_repo "config/recipes/foreman.rb"
    get_from_master_repo "config/recipes/memcached.rb"
    get_from_master_repo "config/recipes/nginx.rb"
    get_from_master_repo "config/recipes/nodejs.rb"
    get_from_master_repo "config/recipes/postgresql.rb"
    get_from_master_repo "config/recipes/rbenv.rb"
    get_from_master_repo "config/recipes/unicorn.rb"
    get_from_master_repo "config/recipes/templates/maintenance.html.erb"
    get_from_master_repo "config/recipes/templates/memcached.erb"
    get_from_master_repo "config/recipes/templates/nginx_unicorn.erb"
    get_from_master_repo "config/recipes/templates/postgresql.yml.erb"
    get_from_master_repo "config/recipes/templates/unicorn.rb.erb"
    get_from_master_repo "config/recipes/templates/unicorn_init.erb"
    get_from_master_repo "config/deploy.rb"

    gsub_file "config/deploy.rb", /\{\{app_name\}\}/, app_name if app_name.present?
    gsub_file "config/deploy.rb", /\{\{server_ip\}\}/, server_ip if server_ip.present?

    bundle_command('install') #needs to be before generators and scaffolding

    # Create database
    gsub_file "config/database.yml", /\{\{db_name\}\}/, app_name if app_name.present?
    gsub_file "config/database.yml", /\{\{db_username\}\}/, db_username if db_username.present?
    gsub_file "config/database.yml", /\{\{db_password\}\}/, "#{db_password}"
    rake("db:create:all")

    # Run generators
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
