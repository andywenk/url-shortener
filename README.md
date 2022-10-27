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

#### admin user

You need to create at least one user to be able to login (`/auth/login`). 

Create a new user in database. First create a bcrypt password locally:

    ~ bundle exec racksh
    >> BCrypt::Password.create('SUPER_SECRET_PASSWORD')
    => 'ENCRYPTED_PASSWORD_STRING'

Then put the data into the database. If you are using e.g. PostgreSQL it is done like this:

	~ psql
	INSERT INTO users (created_at,updated_at, username, password) VALUES ('DATE_TIME','DATE_TIME','USERNAME', 	'ENCRYPTED_PASSWORD_STRING');
    INSERT 0 1
    url-shortener-slug::DATABASE=> select password from users where username='USERNAME';
                              password
    --------------------------------------------------------------
    ENCRYPTED_PASSWORD_STRING
    (1 row)

Remember to do this also in the production database after you deployed for the first time. You need to find the *external connection data* for the database. 

* In the render Dashboard click the database (e.g. postgresql-transparent-1234)
* click the *connect* drop down on the top right side
* choose the tab *External Connection*
* copy the psql string under *PSQL Command - Connect from the command line.*
* past it into the command line

The result will be sth like this:

	➜  url-shortener-git git:(main) PGPASSWORD=SuperSecretPassword psql -h dpg-somesubdomain.someregion-postgres.render.com -U postgresql_transparent_1234_user postgresql_transparent_1234
	psql (15.0 (Homebrew), server 14.5)
	SSL connection (protocol: TLSv1.3, cipher: TLS_AES_128_GCM_SHA256, compression: off)
	Type "help" for help.

	postgresql_transparent_1234=> \dt
	                             List of relations
	 Schema |         Name         | Type  |               Owner
	--------+----------------------+-------+-----------------------------------
	 public | ar_internal_metadata | table | postgresql_transparent_22708_user
	 public | schema_migrations    | table | postgresql_transparent_22708_user
	 public | urls                 | table | postgresql_transparent_22708_user
	 public | users                | table | postgresql_transparent_22708_user
	(4 rows)

### Run the application

**Run the script created in the bin directory.**

    ~ ./bin/run

## Sinatra

Sinatra is a Rack based small web-framework you want to use, when Ruby on Rails is too heavy. A basic overview can be found here: [https://sinatrarb.com/intro#The%20Bleeding%20Edge](https://sinatrarb.com/intro#The%20Bleeding%20Edge)

## Hosting

After the horrible failures with Heroku, I decided to try and go with [render](https://render.com). It just took me 1 hour to get my application running with both URL's krx.pw and www.krx.pw. I strongly propose to go with this really easy service. Follow these steps:

* create a [GitHub](https://github.com) or [GitLab](https://gitlab.com) repository and push the code of your application
* create an [render](https://render.com) account
* set up everything at render by following the instructions described at teh [render docs](https://render.com/docs). Belive me - it is really easy!
* set up a database at render
* deploy the first time
* set up custom domains at render
* set up the DNS settings like described [here](https://render.com/docs/custom-domains). Make sure to use [Cloudflare](https://render.com/docs/configure-cloudflare-dns) or [Namecheap](https://render.com/docs/configure-namecheap-dns). These services are easy to set up and they offer free plans
* check if everything works

## deployment

The deployment at render is automagically started when you push the branch to Github.

	~ git push


###~~~~BELOW THIS LINE READ THE FAILED ATTEMPT WITH HEROKU~~~


## Heroku

### Getting started with Ruby

This is a good overview on how to get started with a [Ruby application on Heroku](https://devcenter.heroku.com/articles/getting-started-with-ruby).

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

### Prerequisites

PostgreSQL has to be installed on your local machine. And the `psql` program has to be in `PATH`. Configure then:

    ~ export DATABASE_URL=postgres://$(whoami)

### user

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

### Addons

You can see the addons you installed with this command:

    ~ heroku addons

If you follow tthis README you will see at least `heroku-postgresql`. I suggest to also provision the [papertrail](https://devcenter.heroku.com/articles/papertrail) addon for better logging.

    ~ heroku addons:create papertrail

Start it with:

    ~ heroku addons:open papertrail

There is also a plugin for yopur local console:

    ~ heroku plugins:install heroku-papertrail

You can run it with

    ~ heroku pt

but I personally favour this:

    ~ heroku logs --tail

The shortlink to the papertrail web ui is simply this:

    https://addons-sso.heroku.com/apps/<YOUR_HEROKU_APP_NAME/addons/papertrail

### Important Heroku CLI commands

**See all CLI commands**

	~ heroku commands

**Inspect the logs continuously**

	~ heroku logs --tail
	
**Restart the application**

	~ heroku restart
	
**Run the console on the machine**

	~ heroku run bash
	
**Check if the certificates are issued**

	~ heroku certs:auto
	
**Run rake tasks**

	~ heroku run rake [RAKE_TASK]
	
**See how the domains are set up**

	~ heroku domains

## curl

Here is an example how to post the data via curl:

    ~ curl -v -s -X POST -F "url[target]=www.andy.de" -F "url[source]=harry" https://www.krx.pw/create 1> /dev/null

## DNS

### Fuckup experience

The domain krx.pw is registered at [Godaddy](https://www.godaddy.com/). I started to use [Cloudflare](https://www.cloudflare.com/) but I completely failed. THe problem is this:

* Godaddy has it's own NS Servers. 
* Heroku is providing SSL certificates (letsencrypt) for all paied plans.  
* Heroku is basically working together with Godaddy but there is a problem, when you want to use the domain `krx.pw` and `www.krx.pw`. It simply will not work correctly even though you redirect.

So digging deep in the web I found some solutions but they did not suffice. So the proposal was to use Cloudflare. And that failed also.

When setting up the NS domains from Heroku in CLoudflare for both `krx.pw` and `www.krx.pw` the domains were reachable. Good. But when using POST, the application returned the HTTP status code `403` what means `forbidden`. After one day of digging and debugging I realised, that Cloudflare is using HTTP/2. There, you cannot set the `Connection close` header - what I tried. When using curl there is no problem at all. Up and down, down and up I finally decided, that it is simply not working. 

Then I went back to Godaddy. But I was again not able to get the `krx.pw` domain working. Only `www.krx.pw`. 

The next suggestion was to use [Namecheap](https://www.namecheap.com/). DNS is also free (as with Cloudflare) and there I am now. The domains are both working but now I  am facing an issue with the SSL certificates provided by Heroku. Meh!

I can't understand why this is so hard. It should be way more simple and I am just a blink away to rent a root server box and do everything by myself. 

