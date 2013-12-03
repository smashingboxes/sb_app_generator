server '{{server_ip}}', :web, :app, :queue, :memcache, :db, primary: true
set :rails_env, 'staging'
