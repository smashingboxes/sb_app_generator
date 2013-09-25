role :web, "{ip}"
role :app, "{ip1}", "{ip2}"
role :queue, "{ip}"
role :memcache, "{ip}"
role :db, "{ip}", primary: true

set :rails_env, 'production' 

set :memcached_memory_limit, 256 #MB
set :unicorn_workers, 3 #usually number of cpus (per app server) + 1
