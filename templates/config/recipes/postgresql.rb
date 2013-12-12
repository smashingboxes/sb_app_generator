set_default :postgresql_host, 'localhost'
set_default(:postgresql_user) { user }
set_default(:postgresql_password) { Capistrano::CLI.password_prompt 'PostgreSQL Password: ' }
set_default(:postgresql_database) { "#{application}_#{rails_env}" }

namespace :postgresql do
  desc 'Install the latest stable release of PostgreSQL.'
  task :install, roles: :db, only: {primary: true} do
    "#{sudo} echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
    "#{sudo} wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -"
    "#{sudo} apt-get -y update"
    "#{sudo} apt-get -y install postgresql-9.3 libpq-dev"
  end

  desc 'Create a database user for the application'
  task :create_user, roles: :db, only: {primary: true} do
    create_user postgresql_user, postgresql_password
  end

  desc 'Create a database for the application'
  task :create_database, roles: :db, only: {primary: true} do
    create_database postgresql_database, postgresql_user
  end

  # Utilities
  def create_database(database, username)
    sudo %{psql -c 'create database "#{database}" owner "#{username}"'}, as: 'postgres'
  rescue
    logger.important 'PostreSQL database already exists'
  end

  def create_user(username, password)
    sudo %{psql -c 'create user "#{username}" with password "#{password}"'}, as: 'postgres'
  rescue
    logger.important 'PostreSQL user already exists'
  end
end

after 'deploy:install', 'postgresql:install'
after 'deploy:setup', 'postgresql:create_user'
after 'postgresql:create_user', 'postgresql:create_database'
