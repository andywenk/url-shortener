# KRX URL shortener

Simple url shortener based on Ruby, Sinatra and a RDBMS - here PostgreSQL in production. 

## Disclaimer

I wrote this application on a weekend in October 2022. The goal was:

* create the most simple, fast and still secure application possible
* don't use anything that is not really needed
* don't use any JavaScript libraries but Vanilla JS if at all
* don't use Ruby on Rails because the overhead is way too big 
* use the simplest way to host the application
* use Ruby because it is fuckin' cool
* buy a domain and deploy to production
* make it easy for anyone to install it with an own domain

All you need is a NIX-box with a new Ruby installed and a database like PostgreSQL. For a pet project you could even use sqlite3. 

You can visit the [KRX website](https://krx.pw) to see the application as a demo running on production. *Be aware that I will most probably delete slugs you have created in the future!*

## Features

* create a named short URL with your domain
* create a random short URL with your domain
* login as an admin and delete short-urls

## 

## local development

### Ruby

You need to install [Ruby 3.2.1](https://www.ruby-lang.org/en/news/2022/04/12/ruby-3-1-2-released/). The easiest way is to use rbenv. Assuming you are 
using MacOS you can follow these stesp:

**Install [Homebrew](https://brew.sh/)**

    ~ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

**Install [rbenv](https://github.com/rbenv/rbenv)**

    ~ brew install rbenv ruby-build
    ~ rbenv init

**Install Ruby 3.2.1**

    ~ rbenv install 3.2.1

Now cd into the directory where you cloned this repo. Then set Ruby to 3.1.2 and check the versio with:

    ~ rbenv local
    ~ ruby -v
    ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [arm64-darwin21]

### bundler

**Install bundler**

    ~ gem install bundler

**Now install all the Ruby gems needed for the project**

    ~ bundle install

You may need to install PostgreSQL. Do this with Homebrew:

    ~ brew install postgresql@14

### Database

Locally sqlite3 will be used. Check out the configuration in `config/database.yml`. To set everything up use Rake:

    ~ rake db:setup

### Run the application

**Run the script created in the bin directory.**

    ~ ./bin/run
    
## Heroku

### CLI

Download the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) and install it. After that make your self familiar with the [CLI](https://devcenter.heroku.com/articles/heroku-cli#get-started-with-the-heroku-cli). If you don't want to [RTFM](https://en.wiktionary.org/wiki/RTFM) fire:

	~ heroku
	CLI to interact with Heroku
	
	VERSION
	  heroku/7.65.0 darwin-x64 node-v14.19.0
	
	USAGE
	  $ heroku [COMMAND]


### deployment

The deployment is automagically started when you push to the Heroku git (if you use it).

	~ git push heroku
	
You can for sure also use another git repository and deploy from there.

### PostgreSQL (production)

https://devcenter.heroku.com/articles/managing-heroku-postgres-using-cli

#### Prerequisites

PostgreSQL has to be installed on your local machine. And the `psql` program has to be in `PATH`. Configure then:

    ~ export DATABASE_URL=postgres://$(whoami)

#### user

You need to create at least one user to be able to login (`/auth/login`). 

Create a new user in production database. First create a bcrypt password locally:

    ~ bundle exec racksh
    >> BCrypt::Password.create('SUPER_SECRET_PASSWORD')
    => 'ENCRYPTED_PASSWORD_STRING'

Then connect to the the production database with `psql`:

    ~ heroku pg:psql
    url-shortener-slug::DATABASE=> INSERT INTO users (created_at,updated_at, username, password) VALUES ('DATE_TIME','DATE_TIME','USERNAME', 'ENCRYPTED_PASSWORD_STRING');
    INSERT 0 1
    url-shortener-slug::DATABASE=> select password from users where username='USERNAME';
                              password
    --------------------------------------------------------------
    ENCRYPTED_PASSWORD_STRING
    (1 row)

