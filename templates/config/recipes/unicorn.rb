set_default(:unicorn_user) { user }
set_default(:unicorn_pid) { "#{current_path}/tmp/pids/unicorn.pid" }
set_default(:unicorn_config) { "#{shared_path}/config/unicorn.rb" }
set_default(:unicorn_log) { "#{shared_path}/log/unicorn.log" }
set_default(:unicorn_workers, 2)

namespace :unicorn do
  desc "Setup Unicorn initializer and app configuration"
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "unicorn.rb.erb", unicorn_config
    template "unicorn_init.erb", "/tmp/unicorn_init"
    run "chmod +x /tmp/unicorn_init"
    run "#{sudo} mv /tmp/unicorn_init /etc/init.d/unicorn_#{application}"
    run "#{sudo} update-rc.d -f unicorn_#{application} defaults"
  end
  after "deploy:setup", "unicorn:setup"

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      run "service unicorn_#{application} #{command}"
      run "tail -n 20 #{unicorn_log}"
    end
    after "deploy:#{command}", "unicorn:#{command}"
  end

  before "unicorn:restart", "deploy:assets:precompile"
  before "unicorn:start", "deploy:assets:precompile"
  
  # desc "Run bundle install"
  # task :bundle_install, roles: :app do
  #   run "cd #{current_path}; bundle install"
  # end
  # before "unicorn:restart", "unicorn:bundle_install"
end


# desc "Zero-downtime restart of Unicorn"
# task :restart, :except => { :no_release => true } do
#   run "kill -s USR2 `cat #{shared_path}/pids/unicorn.pid`"
# end

# desc "Start unicorn"
# task :start, :except => { :no_release => true } do
#   run "cd #{current_path} ; bundle exec unicorn_rails -c config/unicorn.rb -D -E production"
# end

# desc "Stop unicorn"
# task :stop, :except => { :no_release => true } do
#   run "kill -s QUIT `cat #{shared_path}/pids/unicorn.pid`"
# end