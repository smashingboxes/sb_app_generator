namespace :paperclip do

  desc "Install paperclip requirements"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install imagemagick libmagickcore-dev libmagickwand-dev"
  end
  after "deploy:install", "paperclip:install"


  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles, :roles => :app do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} bundle exec rake paperclip:refresh:missing_styles"
  end
  after "deploy:update_code", "paperclip:build_missing_paperclip_styles"
end
