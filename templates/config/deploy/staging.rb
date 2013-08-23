server "{{server_ip}}", :web, :app, :queue, :db, primary: true
set :rails_env, 'staging' 

