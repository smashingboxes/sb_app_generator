namespace :shared do
  desc "Generate the .yml configuration file."
  task :setup, roles: :app do
    run "mkdir -p #{shared_path}/config"
    template "postgresql.yml.erb", "#{shared_path}/config/database.yml"
    template "secrets.yml.erb", "#{shared_path}/config/secrets.yml"
  end
  after "deploy:setup", "shared:setup"

  desc "Symlink the .yml file into latest release"
  task :symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/secrets.yml #{release_path}/config/secrets.yml"
  end
  after "deploy:finalize_update", "shared:symlink"
end