
role :web, "{ip}"
role :app, "{ip1}", "{ip2}"
role :queue, "{ip}"
role :memcache, "{ip}"
role :db, "{ip}", primary: true

set :rails_env, 'production' 
