require 'capistrano'
require 'json'
require 'net/http'
require 'active_support/all'

before 'deploy:update_code', 'slack:capture_last_commit'

def slack_connect(message)
  uri = URI.parse("https://#{fetch(:slack_subdomain)}.slack.com/services/hooks/incoming-webhook?token=#{fetch(:slack_token)}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  request = Net::HTTP::Post.new(uri.request_uri)
  request.set_form_data(:payload => payload(message))
  http.request(request)
end

def slack_defaults 
  if fetch(:slack_deploy_defaults, true) == true
    after 'deploy',  'slack:finished'
    after 'deploy:migrations',  'slack:finished'
  end
end

def self.extended(configuration)
  configuration.load do
    slack_defaults
  end
end

set :deployer do
  ENV['GIT_AUTHOR_NAME'] || `git config user.name`.chomp
end

def payload(announcement)
  {
    'channel' => fetch(:slack_room),
    'username' => fetch(:slack_username), 
    'text' => announcement, 
    'icon_emoji' => fetch(:slack_emoji)
  }.to_json
end

namespace :slack do
  task :capture_last_commit do
    set :last_commit, capture("cd #{current_path} && git rev-parse HEAD").strip!
  end

  task :finished do
    set :this_commit, capture("cd #{current_path} && git rev-parse HEAD").strip!
    return if slack_token.nil?
    announced_deployer = fetch(:deployer)
    github_diff = "[diff](https://github.com/smashingboxes/actual_id/compare/#{last_commit}...#{this_commit})"
    msg = "@channel #{announced_deployer} deployed #{slack_application} to #{rails_env}. #{(show_diff_in_slack)? github_diff : ''}"
    slack_connect(msg)
  end
end
