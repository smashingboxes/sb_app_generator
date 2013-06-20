# Smashing Boxes App generator
Makes building apps faster and more fun!

## Pre-Setup

## Usage
###Automatic (recommended)

```
echo '-m https://raw.github.com/smashingboxes/sb_app_generator/master/app_generator.rb --skip-bundle' > ~/.railsrc
```

Make sure you have `ruby 2.0` and `rails 4.0` installed

```
ruby -v
rails -v
gem install rails -v "~> 4.0.0.rc2"
```

then create your app

```
rails new your_app_name
```

###Manual
```
rails new your_app_name -m https://raw.github.com/smashingboxes/sb_app_generator/master/app_generator.rb --skip-bundle
```

## Troubleshoot

### Updating from rails3 to rails4
change `-b` to `-m` in `~/.railsrc`
If you wish to stay with rails3, use
```
rails new your_app_name -b https://github.com/smashingboxes/sb_app_generator/blob/rails3.2/app_generator.rb --skip-bundle
```

### Skip the automatic script
in case of trouble
```
rails new your_app_name --no-rc
```

### Install Posrgres
The generator only supports Postgres right now. Here is the [simplest way to install postgres](http://postgresapp.com/).

### SSL error
Make sure you have the latest ruby >= 1.9.3p362

#### curl-ca-bundle
Installing `curl-ca-bundle` worked for some users.

```
brew install curl-ca-bundle
export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
```

## Project Readme
[Deploy instructions](https://github.com/smashingboxes/sb_app_generator/blob/master/templates/README.md)
