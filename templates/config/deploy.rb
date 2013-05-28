# Capistrano Configuration
# see commands available with cap -T

require 'bundler/capistrano'
require 'capistrano/ext/multistage'

load "config/recipes/base"
load "config/recipes/shared"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
# load "config/recipes/assets"
# load "config/recipes/foreman"
# load "config/recipes/elasticsearch"
# load "config/recipes/dragonfly"
# load "config/recipes/paperclip"
# load "config/recipes/memcached"
load "config/recipes/check"


# Look in config/deploy/production.rb and config/deploy/staging.rb for server config
# server "{{server_ip}}", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "{{app_name}}"

# cap production TASK
# cap staging TASK
# Don't name your stage "stage", as this is a reserved word
set :stages, %w(production staging)
set :default_stage, "staging"

set :deploy_to, "/home/#{user}/www/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false
set :rails_env, 'production' #don't modify

set :scm, "git"
set :repository, "git@github.com:smashingboxes/{{app_name}}.git"
set :branch, "master"
set :remote, 'origin'

set :maintenance_template_path, File.expand_path("../recipes/templates/maintenance.html.erb", __FILE__)

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

# hook to automatically push code before every deploy
before 'deploy:update_code' do
  puts "Pushing #{branch} code to git repository ..."
  system "git push -u #{remote} #{branch}"
  abort unless $?.success?
end

  