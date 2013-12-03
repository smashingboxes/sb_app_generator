set_default :ruby_version, "2.0.0-p353"
# set_default :rbenv_bootstrap, "bootstrap-ubuntu-12-04"

namespace :rbenv do
  desc "Install rbenv, Ruby, and the Bundler gem"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install curl git-core"
    run "curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash"
    bashrc = <<-BASHRC
if [ -d $HOME/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi
BASHRC
    put bashrc, "/tmp/rbenvrc"
    run "cat /tmp/rbenvrc ~/.bashrc > ~/.bashrc.tmp"
    run "mv ~/.bashrc.tmp ~/.bashrc"
    run %q{export PATH="$HOME/.rbenv/bin:$PATH"}
    run %q{eval "$(rbenv init -)"}
    # run "rbenv #{rbenv_bootstrap}"
    # Start of bootstrap file: Source code used for the sudo problem
    run "#{sudo} apt-get -y install build-essential"
    run "#{sudo} apt-get -y install zlib1g-dev libssl-dev"
    run "#{sudo} apt-get -y install libreadline-gplv2-dev"
    # End of bootstrap file
    run "rbenv install #{ruby_version} --force"
    run "rbenv global #{ruby_version}"
    run "gem install bundler --no-ri --no-rdoc"
    run "rbenv rehash"
  end
  after "deploy:install", "rbenv:install"
end
