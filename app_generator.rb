# http://guides.rubyonrails.org/rails_application_templates.html

REMOTE_BASE_PATH = 'https://raw.github.com/smashingboxes/sb_app_generator/master'

def download_file(file_path)
  remove_file file_path
  get "#{REMOTE_BASE_PATH}/templates/#{file_path}", file_path
end

whoami = run('whoami', capture: true).strip

# Layout
remove_file 'app/views/layouts/application.html.erb'
download_file 'app/views/layouts/application.html.slim'

# Readme
remove_file 'README.rdoc'
download_file 'README.md'
gsub_file 'README.md', /\{\{app_name\}\}/, app_name if app_name.present?

# Test
empty_directory_with_keep_file 'test/factories'
empty_directory 'test/support'
download_file 'test/support/bootstrap_macros.rb'
download_file 'test/test_helper.rb'
download_file 'Guardfile'
download_file 'config/initializers/generators.rb'

# Gemfile
download_file 'Gemfile'

# Gem initializers
download_file 'config/initializers/time_formats.rb'

# .gitignore
remove_file '.gitignore'
get "#{REMOTE_BASE_PATH}/git/.gitignore", '.gitignore'

# Modify application.rb

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
environment nil, env: 'production' do
  <<-EOS

  config.action_mailer.delivery_method = :sendmail #:smtp #emails might go to spam if you don't change to smtp

  #Automatic email on exception
  config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[site_name Error] ",
    :sender_address => %{"Error notifier" <noreply@smashingboxes.com>},
    :exception_recipients => %w{your_name@smashingboxes.com}
  }
EOS
end

environment 'config.action_mailer.delivery_method = :letter_opener', env: 'development'
run 'cp config/environments/production.rb config/environments/staging.rb'
gsub_file 'config/environments/production.rb', /(config\.log_level\ \=\ \:)info/, '\1error'

# Modify assets
run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.scss'
download_file 'app/assets/stylesheets/application.css.scss'
download_file 'app/assets/javascripts/application.js'

# Settings
gsub_file 'config/initializers/secret_token.rb', /(.*\:\:Application\.config\.secret_key_base\ =\ )'.*'/, '\1Env.secret_token'
download_file 'config/env_config.yml'
download_file 'config/env_config_example.yml'
download_file 'lib/env.rb'

# bundle (before database creation)
run_bundle

download_file 'Procfile'

# Capistrano
download_file 'config/deploy.rb'
empty_directory_with_keep_file 'config/deploy'
download_file 'config/deploy/production.rb'
download_file 'config/deploy/staging.rb'
bundle_command 'exec capify . > /dev/null 2> /dev/null'
gsub_file 'Capfile', %r{^\s*# load 'deploy/assets'}, "load 'deploy/assets'"
empty_directory_with_keep_file 'config/recipes/templates'
download_file 'config/recipes/base.rb'
download_file 'config/recipes/check.rb'
download_file 'config/recipes/dragonfly.rb'
download_file 'config/recipes/paperclip.rb'
download_file 'config/recipes/elasticsearch.rb'
download_file 'config/recipes/foreman.rb'
download_file 'config/recipes/memcached.rb'
download_file 'config/recipes/nginx.rb'
download_file 'config/recipes/nodejs.rb'
download_file 'config/recipes/postgresql.rb'
download_file 'config/recipes/rbenv.rb'
download_file 'config/recipes/unicorn.rb'
download_file 'config/recipes/shared.rb'
download_file 'config/recipes/templates/maintenance.html.erb'
download_file 'config/recipes/templates/memcached.erb'
download_file 'config/recipes/templates/nginx_unicorn.erb'
download_file 'config/recipes/templates/postgresql.yml.erb'
download_file 'config/recipes/templates/unicorn.rb.erb'
download_file 'config/recipes/templates/unicorn_init.erb'
download_file 'config/recipes/templates/env_config.yml.erb'
gsub_file 'config/deploy.rb', /\{\{app_name\}\}/, app_name if app_name.present?

# Create database
download_file 'config/database.yml'
run 'cp config/database.yml config/database_example.yml'

db_username = whoami
db_password = ''
gsub_file 'config/database.yml', /\{\{db_name\}\}/, app_name if app_name.present?
gsub_file 'config/database.yml', /\{\{db_username\}\}/, db_username if db_username.present?
gsub_file 'config/database.yml', /\{\{db_password\}\}/, db_password

rake 'db:create:all'

remove_file 'public/index.html'

run 'git init . > /dev/null'
run 'git add . > /dev/null'
run "git commit -m 'initial commit'  > /dev/null"
