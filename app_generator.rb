# https://github.com/rails/rails/blob/v3.2.13/railties/lib/rails/generators/rails/app/app_generator.rb

class AppBuilder < Rails::AppBuilder
  def initialize(generator)
    super(generator)

    @master_url = 'https://raw.github.com/smashingboxes/sb_app_generator/master'
  end

  def get_from_master_repo(file_path)
    get "#{@master_url}/templates/#{file_path}", file_path
  end
  def get_from_file(file_path)
    get "#{File.expand_path File.dirname(__FILE__)}/templates/#{file_path}", file_path
  end

  def readme
    get_from_master_repo 'README.md'
    gsub_file 'README.md', /\{\{app_name\}\}/, app_name if app_name.present?
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
    get_from_master_repo 'Gemfile'
  end  

  def gitignore
    git :init
    get "#{@master_url}/git/.gitignore", '.gitignore' #solves env_config.yml not being included
  end

  def database_yml
    get_from_master_repo 'config/database.yml'
    run 'cp config/database.yml config/example_database.yml'
  end

  def config
    super
    # Strong parameters
    get_from_master_repo 'config/initializers/strong_parameters.rb'
    gsub_file 'config/application.rb', /(\s*config\.active_record\.whitelist_attributes\ =\ )true/, '\1false'
    gsub_file 'config/application.rb', /\#\ config\.autoload_paths\ \+=\ \%W\(\#\{config\.root\}\/extras\)/, "config\.autoload_paths\ \+=\ \%W\(\#\{config\.root\}\/lib\)"

    # settings
    gsub_file "config/initializers/secret_token.rb", /(.*\:\:Application\.config\.secret_token\ =\ )'.*'/, '\1Env.secret_token'
    get_from_master_repo 'config/env_config.yml'
    get_from_master_repo 'lib/env.rb'  
  end
  
  def leftovers
    # bundle (before database creation)
    bundle_command('update') # also does bundle install

    whoami = run('whoami', capture: true).strip
    # server_ip = ask "What is the IP of your production server (leave empty if you don't know it yet)? "
    db_username = ask("Database Username [#{whoami}]: ").underscore
    db_username = db_username.empty? ? whoami : db_username
    db_password = ask('Database Password []: ').underscore

    get_from_master_repo 'Procfile'


    # Capistrano
    get_from_master_repo 'config/deploy.rb'
    empty_directory_with_gitkeep 'config/deploy'
    get_from_master_repo 'config/deploy/production.rb'
    get_from_master_repo 'config/deploy/staging.rb'
    capify!
    gsub_file 'Capfile', "# load 'deploy/assets'", "load 'deploy/assets'"
    empty_directory_with_gitkeep 'config/recipes/templates'
    get_from_master_repo 'config/recipes/base.rb'
    get_from_master_repo 'config/recipes/check.rb'
    get_from_master_repo 'config/recipes/dragonfly.rb'
    get_from_master_repo 'config/recipes/paperclip.rb'
    get_from_master_repo 'config/recipes/elasticsearch.rb'
    get_from_master_repo 'config/recipes/foreman.rb'
    get_from_master_repo 'config/recipes/memcached.rb'
    get_from_master_repo 'config/recipes/nginx.rb'
    get_from_master_repo 'config/recipes/nodejs.rb'
    get_from_master_repo 'config/recipes/postgresql.rb'
    get_from_master_repo 'config/recipes/rbenv.rb'
    get_from_master_repo 'config/recipes/unicorn.rb'
    get_from_master_repo 'config/recipes/templates/maintenance.html.erb'
    get_from_master_repo 'config/recipes/templates/memcached.erb'
    get_from_master_repo 'config/recipes/templates/nginx_unicorn.erb'
    get_from_master_repo 'config/recipes/templates/postgresql.yml.erb'
    get_from_master_repo 'config/recipes/templates/unicorn.rb.erb'
    get_from_master_repo 'config/recipes/templates/unicorn_init.erb'

    gsub_file 'config/deploy.rb', /\{\{app_name\}\}/, app_name if app_name.present?
    # gsub_file 'config/deploy.rb', /\{\{server_ip\}\}/, server_ip if server_ip.present?

    # Create database
    gsub_file 'config/database.yml', /\{\{db_name\}\}/, app_name if app_name.present?
    gsub_file 'config/database.yml', /\{\{db_username\}\}/, db_username if db_username.present?
    gsub_file 'config/database.yml', /\{\{db_password\}\}/, db_password
    
    rake('db:create:all')

    # Run generators (after database creation)
    generate 'simple_form:install --bootstrap'

    if yes? 'Do you want to generate a root controller? [n]'
      name = ask('What should it be called? [main]').underscore
      name = "main" if name.blank?
      generate :controller, "#{name} index"
      route "root to: '#{name}\#index'"
      remove_file 'public/index.html'
    end

    run "git add . > /dev/null"
    run "git commit -m 'initial commit'  > /dev/null"

    run "curl 'http://artii.herokuapp.com/make?text=Thanks%20#{whoami}!'"
    say "You're welcome, from Michael and Leonel"
  end
end
