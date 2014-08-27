# {{app_name}}
Todo... add some description of the app and the company

## Development Setup Instructions
```shell
cp config/env_config_example.yml config/env_config.yml
cp config/database_example.yml config/database.yml
# edit your database.yml
bundle install
rake db:create db:migrate db:seed
rails s
```

## Server Setup Instructions
Todo: add the staging and production ips...

### First time deployment

1) create deployer user and generate a key
```
ssh root@your-server-ip
adduser deployer --ingroup sudo
vi /etc/ssh/sshd_config
# PasswordAuthentication no
su deployer
mkdir ~/.ssh/
sudo cp /root/.ssh/authorized_keys ~/.ssh/
sudo chown deployer:sudo ~/.ssh/authorized_keys
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub
```

2) Copy paste the content of that file (id_rsa.pub) and update your project settings on github:

https://github.com/smashingboxes/{{app_name}}/settings/keys


2) Edit the config/deploy.rb with the correct settings

3) Run:
```
cap deploy:install
cap deploy:setup
# edit shared/config/env_config.yml on the server
# ALSO add ENV["SECRET_KEY_BASE"]
cap deploy:cold
```


### Update deployment
```
cap deploy
```
This will fetch the latest from github

### Manual restart
see `cap -T`

Example:
```
cap unicorn:stop unicorn:start
```

### Troubleshoot

#### Man in the middle
If you change the ip of a server but not its name you might get such warning. To get rid of it, use
```
ssh-keygen -R old_ip
```

#### Problem with rbenv
Make sure you have your user using bash shell and that there is a home folder with a bashrc file. This is really only a problem if you created your deployer user manually (not using the above command)
