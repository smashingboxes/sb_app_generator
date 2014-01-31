set_default(:unicorn_user) { user }
set_default(:unicorn_pid) { "#{current_path}/tmp/pids/unicorn.pid" }
set_default(:unicorn_sock) { "/tmp/unicorn.#{application}.sock" }
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

  %w[start stop restart upgrade].each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      run "service unicorn_#{application} #{command}"
      run "tail -n 40 #{unicorn_log}"
    end
    # after "deploy:#{command}", "unicorn:#{command}"
  end
  after "deploy:start", "unicorn:start"
  after "deploy:stop", "unicorn:stop"
  after "deploy:restart", "unicorn:restart"

  desc "Force hard Unicorn restart"
  task :force_reboot, roles: :app do
    run "service unicorn_#{application} stop"
    run "service unicorn_#{application} start"
  end

end

# if you get PG::Error: SSL SYSCALL error: EOF detected, uncomment the lines below
# before_fork do |server, worker|
#   defined?(ActiveRecord::Base) and
#       ActiveRecord::Base.connection.disconnect!
# end

# after_fork do |server, worker|
#   defined?(ActiveRecord::Base) and
#       ActiveRecord::Base.establish_connection
# end
