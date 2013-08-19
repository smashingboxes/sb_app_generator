# http://guides.rubyonrails.org/rails_application_templates.html

@master_url = 'https://raw.github.com/smashingboxes/sb_app_generator/master'


def get_from_master_repo(file_path)
    remove_file file_path
    get "#{@master_url}/templates/#{file_path}", file_path
end
def get_from_file(file_path)
    remove_file file_path
    get "#{File.expand_path File.dirname(__FILE__)}/templates/#{file_path}", file_path
end

# readme
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

# gitignore
remove_file ".gitignore"
get "#{@master_url}/git/.gitignore", '.gitignore' #solves env_config.yml not being included

# database_yml
get_from_master_repo 'config/database.yml'
run 'cp config/database.yml config/database_example.yml'

#modify application.rb
gsub_file 'config/application.rb', /\#\ config\.time_zone\ \=\ \'Central\ Time\ \(US\ \&\ Canada\)\'/, "config.time_zone = 'Eastern Time (US & Canada)'"
gsub_file 'config/application.rb', /(\n\s*end\nend)/, "\n\n    # Custom directories with classes and modules you want to be autoloadable.\n    config.autoload_paths += %W(\#\{config.root\}/lib)" + '\1'

# modify production.rb
gsub_file 'config/environments/production.rb', /\#\ (config\.action_dispatch\.x_sendfile_header\ \=\ \'X-Accel-Redirect\')/, '\1'
gsub_file 'config/environments/development.rb', /(\n\s*end)/, "\n\n  config.action_mailer.delivery_method = :letter_opener\\1"

# settings
gsub_file "config/initializers/secret_token.rb", /(.*\:\:Application\.config\.secret_key_base\ =\ )'.*'/, '\1Env.secret_token'
get_from_master_repo 'config/env_config.yml'
get_from_master_repo 'config/env_config_example.yml'
get_from_master_repo 'lib/env.rb'  

# bundle (before database creation)
bundle_command('update') # also does bundle install

whoami = run('whoami', capture: true).strip
db_username = whoami
db_password = ""
# server_ip = ask "What is the IP of your production server (leave empty if you don't know it yet)? "
# db_username = ask("Database Username [#{whoami}]: ").underscore
# db_password = ask('Database Password []: ').underscore
# db_username = db_username.empty? ? whoami : db_username
get_from_master_repo 'Procfile'

# Capistrano
get_from_master_repo 'config/deploy.rb'
empty_directory_with_keep_file 'config/deploy'
get_from_master_repo 'config/deploy/production.rb'
get_from_master_repo 'config/deploy/staging.rb'
capify!
gsub_file 'Capfile', "# load 'deploy/assets'", "load 'deploy/assets'"
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
get_from_master_repo 'config/recipes/templates/maintenance.html.erb'
get_from_master_repo 'config/recipes/templates/memcached.erb'
get_from_master_repo 'config/recipes/templates/nginx_unicorn.erb'
get_from_master_repo 'config/recipes/templates/postgresql.yml.erb'
get_from_master_repo 'config/recipes/templates/unicorn.rb.erb'
get_from_master_repo 'config/recipes/templates/unicorn_init.erb'
get_from_master_repo 'config/recipes/templates/env_config.yml.erb'

gsub_file 'config/deploy.rb', /\{\{app_name\}\}/, app_name if app_name.present?
# gsub_file 'config/deploy.rb', /\{\{server_ip\}\}/, server_ip if server_ip.present?

# Create database
gsub_file 'config/database.yml', /\{\{db_name\}\}/, app_name if app_name.present?
gsub_file 'config/database.yml', /\{\{db_username\}\}/, db_username if db_username.present?
gsub_file 'config/database.yml', /\{\{db_password\}\}/, db_password

rake('db:create:all')

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
run "git commit -m 'initial commit'  > /dev/null"

run "curl 'http://artii.herokuapp.com/make?text=Thanks%20#{whoami}!'"
say "You're welcome, from Michael and Leonel"


