# http://guides.rubyonrails.org/rails_application_templates.html

@master_url = 'https://raw.github.com/smashingboxes/sb_app_generator/master'

whoami = run('whoami', capture: true).strip

def get_from_master_repo(file_path)
    remove_file file_path
    get "#{@master_url}/templates/#{file_path}", file_path
end
def get_from_file(file_path)
    remove_file file_path
    get "#{File.expand_path File.dirname(__FILE__)}/templates/#{file_path}", file_path
end

# Layout
remove_file 'app/views/layouts/application.html.erb'
get_from_master_repo 'app/views/layouts/application.html.slim'

# readme
remove_file "README.rdoc"
get_from_master_repo 'README.md'
gsub_file 'README.md', /\{\{app_name\}\}/, app_name if app_name.present?

# test
empty_directory_with_keep_file 'test/factories'
empty_directory 'test/support'
get_from_master_repo 'test/support/bootstrap_macros.rb'
get_from_master_repo 'test/test_helper.rb'
get_from_master_repo 'Guardfile'
get_from_master_repo 'config/initializers/generators.rb'

# gemfile
get_from_master_repo 'Gemfile'

# Gem initializers
get_from_master_repo 'config/initializers/time_formats.rb'

# gitignore
remove_file ".gitignore"
get "#{@master_url}/git/.gitignore", '.gitignore' #solves secrets.yml not being included

#modify application.rb

gsub_file 'config/application.rb', %r{(^\s*class Application < Rails::Application)}, <<-EOS
\\1
    require_relative '../lib/env.rb'
EOS
gsub_file 'config/application.rb', /\#\ config\.time_zone\ \=\ \'Central\ Time\ \(US\ \&\ Canada\)\'/, "config.time_zone = 'Eastern Time (US & Canada)'"
gsub_file 'config/application.rb', /(\n\s*end\nend)/, <<-EOS

    # Email default url host
    config.action_mailer.default_url_options = { :host => Env.host }
\\1

EOS

# modify production.rb
gsub_file 'config/environments/production.rb', /\#\ (config\.action_dispatch\.x_sendfile_header\ \=\ \'X-Accel-Redirect\')/, '\1'
gsub_file 'config/environments/production.rb', /\#\ (config\.cache_store\ \=\ \:mem_cache_store)/, '\1'
gsub_file 'config/environments/production.rb', /(\n\s*end)/, <<-EOS

  config.action_mailer.delivery_method = :sendmail #:smtp #emails might go to spam if you don't change to smtp

  #Automatic email on exception
  config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[site_name Error] ",
    :sender_address => %{"Error notifier" <noreply@smashingboxes.com>},
    :exception_recipients => %w{your_name@smashingboxes.com}
  }
\\1
EOS

gsub_file 'config/environments/development.rb', /(\n\s*end)/, <<-EOS

  config.action_mailer.delivery_method = :letter_opener

  #Uncomment to use absolute paths for assets, added for using asset pipeline in email templates.
  #Sets config.action_controller.asset_host and config.action_mailer.asset_host
  #config.asset_host = 'http://localhost:3000'

\\1
EOS

run 'cp config/environments/production.rb config/environments/staging.rb'
gsub_file 'config/environments/production.rb', /(config\.log_level\ \=\ \:)info/, '\1error'

# modify assets
run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss"
get_from_master_repo 'app/assets/stylesheets/application.css.scss'
get_from_master_repo 'app/assets/javascripts/application.js'

# settings
get_from_master_repo 'config/secrets.yml'
get_from_master_repo 'config/secrets_example.yml'
get_from_master_repo 'lib/env.rb'

# Locales
get_from_master_repo 'config/locales/en.yml'

# bundle (before database creation)
bundle_command('update') # also does bundle install

get_from_master_repo 'Procfile'

# Capistrano
get_from_master_repo 'config/deploy.rb'
empty_directory_with_keep_file 'config/deploy'
get_from_master_repo 'config/deploy/production.rb'
get_from_master_repo 'config/deploy/staging.rb'

log :capify, ""
in_root { run("bundle exec #{extify(:capify)} .", verbose: false) }

gsub_file 'Capfile', %r{^\s*# load 'deploy/assets'}, "load 'deploy/assets'"
empty_directory_with_keep_file 'config/recipes/templates'
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
get_from_master_repo 'config/recipes/shared.rb'
get_from_master_repo 'config/recipes/users.rb'
get_from_master_repo 'config/recipes/templates/maintenance.html.erb'
get_from_master_repo 'config/recipes/templates/memcached.erb'
get_from_master_repo 'config/recipes/templates/nginx_unicorn.erb'
get_from_master_repo 'config/recipes/templates/postgresql.yml.erb'
get_from_master_repo 'config/recipes/templates/unicorn.rb.erb'
get_from_master_repo 'config/recipes/templates/unicorn_init.erb'
get_from_master_repo 'config/recipes/templates/secrets.yml.erb'
gsub_file 'config/deploy.rb', /\{\{app_name\}\}/, app_name if app_name.present?

# Create database
get_from_master_repo 'config/database.yml'
run 'cp config/database.yml config/database_example.yml'
# db_username = ask("Database Username [#{whoami}]: ").underscore
# db_password = ask('Database Password []: ').underscore
# db_username = db_username.empty? ? whoami : db_username
db_username = whoami
db_password = ""
gsub_file 'config/database.yml', /\{\{db_name\}\}/, app_name if app_name.present?
gsub_file 'config/database.yml', /\{\{db_username\}\}/, db_username if db_username.present?
gsub_file 'config/database.yml', /\{\{db_password\}\}/, db_password

rake('db:create:all')

# Robots.txt with sitemap
route "get '/robots', to: 'application\#robots', format: 'txt'"
remove_file 'public/robots.txt'
empty_directory_with_keep_file 'app/views/application'
get_from_master_repo 'app/views/application/robots.text.erb'

# Run generators (after database creation)
# generate 'simple_form:install --bootstrap'

# if yes? 'Do you want to generate a root controller? [n]'
#   name = ask('What should it be called? [main]').underscore
#   name = "main" if name.empty?
#   generate :controller, "#{name} index"
#   route "root to: '#{name}\#index'"
#   remove_file 'public/index.html'
# end
remove_file 'public/index.html'

git :init
run "git add . > /dev/null"
run "git rm config/secrets.yml"
run "git commit -m 'initial commit'  > /dev/null"


say "   _____                     _     _             ____                    
  / ____|                   | |   (_)           |  _ \\                   
 | (___  _ __ ___   __ _ ___| |__  _ _ __   __ _| |_) | _____  _____ ___ 
  \\___ \\| '_ ` _ \\ / _` / __| '_ \\| | '_ \\ / _` |  _ < / _ \\ \\/ / _ \\ __|
  ____) | | | | | | (_| \\__ \\ | | | | | | | (_| | |_) | (_) >  <  __\\__ \
 |_____/|_| |_| |_|\\__,_|___/_| |_|_|_| |_|\\__, |____/ \\___/_/\\_\\___|___/
                                            __/ |                        
                                           |___/                         "
