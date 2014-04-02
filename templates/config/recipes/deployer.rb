namespace :user do
# cap user:add USER=github_username
  task :add do
    github_user = ENV['USER']
    user_keys = "#{github_user}.keys"
    run "wget http://github.com/#{user_keys}"
    run "cat #{user_keys} | awk '{ print $0}' | while read line; do echo \"$line #{github_user}\" >> ~/.ssh/authorized_keys; done"
  end
# cap user:remove USER=github_username
  task :remove do
    github_user = ENV['USER']
    run "cat ~/.ssh/authorized_keys | grep -v #{github_user} | > ~/.ssh/authorized_keys"
  end
end
