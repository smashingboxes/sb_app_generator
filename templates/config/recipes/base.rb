def template(from, to)
  erb = File.read(File.expand_path("../templates/#{from}", __FILE__))
  put ERB.new(erb).result(binding), to
end

def set_default(name, *args, &block)
  set(name, *args, &block) unless exists?(name)
end

def remote_folder_exists?(full_path)
  'true' ==  capture("if [ -d #{full_path} ]; then echo 'true'; fi").strip
end

namespace :deploy do
  desc "Install everything onto the server"
  task :install do
    run "#{sudo} apt-get -y update"
    run "#{sudo} apt-get -y install python-software-properties software-properties-common libxslt-dev libxml2-dev"
  end

  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      begin
        from = source.next_revision(current_revision) # <-- Fail here at first-time deploy
      rescue
        err_no = true
      end
      if err_no || capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end
