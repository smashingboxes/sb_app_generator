# {{app_name}}

## Development Setup Instructions

## Server Setup Instructions

### First time deployment

1) create deployer user and generate a key
```
ssh root@your-server-ip
adduser deployer --ingroup sudo
su deployer
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
```
cap unicorn:stop
cap unicorn:start 
```

### Troubleshoot

#### Assets precompilation error
Make sure the assets are precompiled
```
cap deploy:assets:precompile
cap unicorn:restart
```
