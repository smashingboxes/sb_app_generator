## Slack

Set `show_diff_in_slack` to true in the stages that you want

CONFIG OPTIONS (put these in deploy.rb)
```
set :slack_token, <TOKEN>
set :slack_room, <ROOM NAME>
set :slack_subdomain, "smashingboxes"
after 'deploy', 'slack:finished'
set :slack_application, <APPLICATION NAME>
set :slack_username, "Deployer"
set :slack_emoji, ":rocket:"
```
