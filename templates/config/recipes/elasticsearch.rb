set_default(:elasticsearch_version, "0.19.10")
set_default(:elasticsearch_prefix, "/usr/local")
set_default(:elasticsearch_dir) { "#{elasticsearch_prefix}/elasticsearch-#{elasticsearch_version}" }
set_default(:elasticsearch_data_dir) { "/mnt/elasticsearch/data"}
set_default(:elasticsearch_work_dir) { "/mnt/elasticsearch/work"}
set_default(:elasticsearch_log_dir) { "/mnt/elasticsearch/logs"}
set_default(:elasticsearch_pid_file) { "/var/run/elasticsearch.pid"}
set_default(:elasticsearch_http_port, 9200)
# /usr/local/elasticsearch-0.19.10
namespace :elasticsearch do

  desc "Install latest stable release of elasticsearch"
  task :install, roles: :elasticsearch do
    run "#{sudo} apt-get -y install openjdk-7-jre-headless"
    unless remote_folder_exists?(elasticsearch_dir)
      run "#{sudo} wget --no-check-certificate -qNP /tmp https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-#{elasticsearch_version}.zip"
      run "#{sudo} unzip -d #{elasticsearch_prefix} /tmp/elasticsearch-#{elasticsearch_version}.zip"
      run "#{sudo} rm /tmp/elasticsearch-#{elasticsearch_version}.zip"
      run "cd ~"
      run "curl -L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz"
      run "#{sudo} mv *servicewrapper*/service #{elasticsearch_dir}/bin"
      run "rm -Rf *servicewrapper*"
      run "#{sudo} #{elasticsearch_dir}/bin/service/elasticsearch install"
      sudo "ln -s `readlink -f #{elasticsearch_dir}/bin/service/elasticsearch` /usr/local/bin/rcelasticsearch"

      run "cd #{elasticsearch_dir}/bin/service"
      run "mv elasticsearch.conf elasticsearch.conf.bak"
      run "sed -e 's/ES_HEAP_SIZE=1024/ES_HEAP_SIZE=128/g' elasticsearch.conf.bak > elasticsearch.conf.bak1"
      run "sed -e 's/ES_HOME=<Path to ElasticSearch Home>/ES_HOME=#{elasticsearch_dir}/g' elasticsearch.conf.bak1 > elasticsearch.conf"
      # set.default.ES_HOME=<Path to ElasticSearch Home>
      # set.default.ES_HEAP_SIZE=1024

    end
  end
  after "deploy:install", "elasticsearch:install"
  
  desc "start elasticsearch"
  task :start, :roles => :elasticsearch do
    run "#{sudo} service elasticsearch start"
  end
  before "deploy:start", "elasticsearch:start"

  desc "stop elasticsearch"
  task :stop, :roles => :elasticsearch do
    run "#{sudo} service elasticsearch  stop"
  end
  after "deploy:stop", "elasticsearch:stop"

  desc "restart elasticsearch"
  task :restart, :roles => :elasticsearch do
    run "#{sudo} service elasticsearch stop"
    run "#{sudo} service elasticsearch start"
  end
  # before "deploy:restart", "elasticsearch:restart"

  desc "reindex elasticsearch items"
  task :reindex, :roles => :elasticsearch do
    run "cd #{current_path};#{rake} RAILS_ENV=#{rails_env} environment tire:import CLASS='Bulletin' FORCE=true"
  end
end
