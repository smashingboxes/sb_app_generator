# Project Name

## Development Setup Instructions

## Server Setup Instructions

### First time deployment

1) create deployer user
```
ssh root@your-server-ip
adduser deployer --ingroup sudo
su deployer
ssh-keygen -t rsa
cat ~/.ssh/id_rsa.pub
```

Then copy paste that file to:
```
https://github.com/smashingboxes/yourapp/settings/keys
```

2) Edit the config/deploy.rb with the correct settings

3) Run:
```
cap deploy:install
cap deploy:setup
cap deploy:cold
cap deploy
```

### Update deployment
```
cap deploy
```
This will fetch the latest from github

### Manual restart
see `cap -T`

Example:
cap unicorn:stop
cap unicorn:start 


### Troubleshoot

#### Assets precompilation error
Make sure the assets are precompiled
```
cap deploy:assets:precompile
cap unicorn:restart
```