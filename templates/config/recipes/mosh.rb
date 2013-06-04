# http://mosh.mit.edu/
# use instead of ssh (supports bad wifi!)
namespace :mosh do
  desc "Install latest stable release of mosh"
  task :install, roles: :web do
    run "#{sudo} add-apt-repository -y ppa:keithw/mosh" 
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install mosh"
  end
  after "deploy:install", "mosh:install"
end