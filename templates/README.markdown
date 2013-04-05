# Project Name

## Development Setup Instructions

## Server Setup Instructions

### First time deployment

1) create deployer user
ssh root@your-server-ip
adduser deployer --ingroup sudo

2) Edit the config/deploy.rb with the correct settings

3) Run:
```
cap install
cap setup
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
