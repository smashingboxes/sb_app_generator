namespace :dragonfly do

  desc "Install dragonfly requirements"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install imagemagick libmagickcore-dev libmagickwand-dev"
  end
  after "deploy:install", "dragonfly:install"


  desc "Symlink the Rack::Cache files"
  task :symlink, :roles => [:app] do
    run "mkdir -p #{shared_path}/tmp/dragonfly && ln -nfs #{shared_path}/tmp/dragonfly #{release_path}/tmp/dragonfly"
  end
end
after 'deploy:update_code', 'dragonfly:symlink'