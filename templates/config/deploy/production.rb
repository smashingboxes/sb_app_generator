role :web, "{ip}"
role :app, "{ip1}", "{ip2}"
role :queue, "{ip}"
role :memcache, "{ip}"
role :db, "{ip}", primary: true

set :rails_env, 'production' 

set :memcached_memory_limit, 256 #MB
set :unicorn_workers, 3 #usually number of cpus (per app server) + 1

set :branch do
  default_tag = `git tag`.split("\n").last
  tag = Capistrano::CLI.ui.ask "Tag to deploy (make sure to push the tag first): [#{default_tag}] "
  tag = default_tag if tag.empty?
  tag
end
