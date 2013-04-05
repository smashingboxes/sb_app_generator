# Capistrano Configuration
# see commands available with cap -T

require "bundler/capistrano"

load "config/recipes/base"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
# load "config/recipes/foreman"
# load "config/recipes/elasticsearch"
# load "config/recipes/dragonfly"
# load "config/recipes/memcached"
load "config/recipes/check"

server "{{server_ip}}", :web, :app, :db, primary: true

set :user, "deployer"
set :application, "{{app_name}}"
set :deploy_to, "/home/#{user}/www/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

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

  