# Smashing Boxes App generator
Makes building apps faster and more fun!

## Features
- application.html in slim 
- readme in markdown format with outline
- test environment setup (gems and test_helper)
- default Gemfile with SB recommended gems
- basic site protection using rack-attack gem
- set time format default to be human friendly
- best practice .gitignore
- generate .envrc for spring
- setup turbolinks
- default time zone to 'Eastern Time (US & Canada)'
- setup cache_store to use mem_cache_store
- uncomment header 'X-Accel-Redirect' to be used by nginx
- example commented code on how to setup smtp config
- setup letter_opener gem in development
- log level to :error in production (reduce the quantity of logs)
- rename application.css to use SCSS
- stop Rails from generating empty asset and helper files
- secrets.yml defaults and example file
- update gems to latest versions
- basic Profile
- create database
- database.yml example file
- set robots.txt with link to sitemap
- remove public index.html
- git setup and initial commit
- better 404.html default


## Prerequisites
Make sure you have [Ruby 2.0+](http://www.ruby-lang.org/en/) (We recommend you install ruby using [rbenv](https://github.com/sstephenson/rbenv) or [RVM](https://github.com/sstephenson/rbenv)) and [Rails 4.0](http://rubyonrails.org/) installed
```
ruby -v
rails -v
gem install rails
```

### Postgres
Check that you have postgres installed by running `brew info postgres`. You should see `/usr/local/Cellar/postgresql/X.X.X` in the first lines, if you see `Not installed`, install by running `brew install postgres` and following the instructions detailed in the caveats.

## Usage
###Automatic (recommended)
```
echo '-m https://raw.github.com/smashingboxes/sb_app_generator/master/app_generator.rb --skip-bundle' > ~/.railsrc
```

now you will use the generator by default
```
rails new your_app_name
```

but you can skip it using `--no-rc`
```
rails new your_app_name --no-rc
```

###Manual
```
rails new your_app_name -m https://raw.github.com/smashingboxes/sb_app_generator/master/app_generator.rb --skip-bundle
```


### Skip the template
If you create a `~/.railsrc` file and wish to ignore it when creating a new app:
```
rails new your_app_name --no-rc
```

## Project Readme
[Deploy instructions](https://github.com/smashingboxes/sb_app_generator/blob/master/templates/README.md)
