# url-shortener

Simple url shortener based on Ruby 

## local development

Run the script created in bin.

    ~ ./bin/run

## Heroku

### deployment



### PostgreSQL

https://devcenter.heroku.com/articles/managing-heroku-postgres-using-cli

#### Prerequisites

PostgreSQL has to be installed on your local machine. And the `psql` program has to be in `PATH`. Configure then:

    ~ export DATABASE_URL=postgres://$(whoami)

#### user

Create a new user in production database. First create a bcrypt password locally:

    ~ bundle exec racksh
    >> BCrypt::Password.create('SUPER_SECRET_PASSWORD')
    => 'ENCRYPTED_PASSWORD_STRING'

Then connect to the production database with `psql`:

    ~ heroku pg:psql
    url-shortener-slug::DATABASE=> insert into users (created_at,updated_at, username, password) values ('DATE_TIME','DATE_TIME','USERNAME', 'ENCRYPTED_PASSWORD_STRING');
    INSERT 0 1
    url-shortener-slug::DATABASE=> select password from users where username='USERNAME';
                              password
    --------------------------------------------------------------
    ENCRYPTED_PASSWORD_STRING
    (1 row)

