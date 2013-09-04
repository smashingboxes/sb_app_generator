# Smashing Boxes App generator
Makes building apps faster and more fun!

## Prerequisites
Make sure you have [Ruby 2.0](http://www.ruby-lang.org/en/) (We recommend you install ruby using [rbenv](https://github.com/sstephenson/rbenv) or [RVM](https://github.com/sstephenson/rbenv)) and [Rails 4.0](http://rubyonrails.org/) installed
```
ruby -v
rails -v
gem install rails
```

### Postgres
Check that you have postgres installed by running `brew info postgres`. You should see `/usr/local/Cellar/postgresql/X.X.X` in the first lines, if you see `Not installed`, install by running brew install postgres and following the instructions detailed in the caveats.

## Usage
###Automatic (recommended)
```
echo '-m https://raw.github.com/smashingboxes/sb_app_generator/master/app_generator.rb --skip-bundle' > ~/.railsrc
```
---
```
rails new your_app_name
```

###Manual
```
rails new your_app_name -m https://raw.github.com/smashingboxes/sb_app_generator/master/app_generator.rb --skip-bundle
```

## Troubleshoot
### OpenSSL Errors
```
apply  https://raw.github.com/smashingboxes/sb_app_generator/master/app_generator.rb
/Users/USER/.rbenv/versions/2.0.0-p247/lib/ruby/2.0.0/net/http.rb:918:in `connect': SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed (OpenSSL::SSL::SSLError)
```

- Make sure you are using RubyGems 2.0.3 or newer: `gem -v`
- Make sure you are using OpenSSL 1.0.1 or newer: `openssl version`, update with brew: `brew install openssl; brew install curl-ca-bundle`. Make sure you follow the **Caveats**.

### Skip the template
If you create a `~/.railsrc` file and wish to ignore it when creating a new app:
```
rails new your_app_name --no-rc
```

## Project Readme
[Deploy instructions](https://github.com/smashingboxes/sb_app_generator/blob/master/templates/README.md)
