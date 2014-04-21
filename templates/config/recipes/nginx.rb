set_default :use_ssl, false

namespace :nginx do
  desc "Install latest stable release of nginx"
  task :install, roles: :web do
    run "#{sudo} add-apt-repository -y ppa:nginx/stable"
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install nginx"
  end
  after "deploy:install", "nginx:install"

  desc "Setup nginx configuration for this application"
  task :setup, roles: :web do
    template "nginx_unicorn.erb", "/tmp/nginx_conf"
    if use_ssl
      run "mkdir -p #{shared_path}/certs"
      run "cd #{shared_path}/certs; #{sudo} openssl req -subj '/C=US' -new -nodes -keyout server.key -out server.csr"
      run "cd #{shared_path}/certs; #{sudo} openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt"
    end
    run "#{sudo} mv -f /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}"
    run "#{sudo} rm -f /etc/nginx/sites-enabled/default"
    restart
  end
  after "deploy:setup", "nginx:setup"

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
  end
end

# NOTE: I found it necessary to manually fix the init script as shown here
# https://bugs.launchpad.net/nginx/+bug/1033856
