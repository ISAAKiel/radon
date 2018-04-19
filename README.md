[![Build Status](https://travis-ci.org/ISAAKiel/radon.svg?branch=master)](https://travis-ci.org/ISAAKiel/radon) [![Coverage Status](https://img.shields.io/codecov/c/github/ISAAKiel/radon/master.svg)](https://codecov.io/github/ISAAKiel/radon?branch=master) [![Docker Build Status](https://img.shields.io/docker/build/isaakiel/radon.svg)](https://hub.docker.com/r/isaakiel/radon/)

# radon

Ruby on Rails WebApp to interact with one of the largest 14C-Databases online.

## The real RADON

You can see a running version of the application at
[http://radon.ufg.uni-kiel.de/][radon].

[radon]: http://radon.ufg.uni-kiel.de/

## Installation
This application is set up to use [SQLite](https://www.sqlite.org/) by default. Feel free to deploy it with another database system of your choice by altering the database.yml

    git clone git://github.com/ISAAKiel/radon.git
    cd radon
    bundle install

    bundle exec rake db:setup

### Optional
If you want to populate the database with the public available data from Radon (as of July 2016), you can use a rake task

    bundle exec rake db:populate

## Environmental Variables
This application uses [dotenv](https://github.com/bkeepers/dotenv) to set environmental variables need for eg. external apis. Secret Token and Secret Key Base are configured to be set in an environmental variable. Feel free to change this for your local app, or provide them via environment in an .env file in the root folder of the application:

    SECRET_TOKEN = 'xxx'
    SECRET_KEY_BASE = 'xxx'

Additionally, you might register and provide keys for the intigration of [Twitter](https://apps.twitter.com/), [Recaptcha](https://developers.google.com/recaptcha/docs/start) and [Google Maps Javascript API](https://developers.google.com/maps/documentation/javascript/tutorial). Add them to the .env file:

    TWITTER_CONSUMER_KEY = 'xxx'
    TWITTER_CONSUMER_SECRET = 'xxx'
    TWITTER_ACCESS_TOKEN = 'xxx'
    TWITTER_ACCESS_TOKEN_SECRET = 'xxx'

    RECAPTCHA_PUBLIC_KEY  = 'xxx'
    RECAPTCHA_PRIVATE_KEY = 'xxx'
    GOOGLE_MAPS_API_KEY_JAVASCRIPT = 'xxx'

## Usage
    rails server

## Docker 

The prebuild docker container [here](https://hub.docker.com/r/isaakiel/radon/) is probably the most simple way to setup radon in a production environment. The container requires a docker network with a postgres container that provides the database.

You can create the docker network with

`docker network create -d bridge --subnet 192.168.0.0/24 --gateway 192.168.0.1 radon_net`

and a postgres container with

`docker run --name radon_database -e POSTGRES_PASSWORD=a_password --net=radon_net -d postgres:latest`

You should then connect to the database server, create a radon database (probably by restoring a dump of the original radon database) and add a user that acts as owner of this database.

Finally you can run the radon container with the correct settings for your setup. The DB_HOST IP can vary: You can check it with `docker inspect radon_database`. Please bear in mind that starting the container takes some time, because the assets of the webapp have to be precompiled. 

`docker run -d -p 80:80 --net=radon_net --name radon_webapp -e DB_HOST=192.168.0.2 -e DB_PORT=5432 -e DB_NAME=a_name -e DB_USER=a_name -e DB_USER_PW=a_password -e RECAPTCHA_PRIVATE_KEY=a_key -e RECAPTCHA_PUBLIC_KEY=a_key -e TWITTER_ACCESS_TOKEN=a_key -e TWITTER_ACCESS_TOKEN_SECRET=a_key -e TWITTER_CONSUMER_KEY=a_key -e TWITTER_CONSUMER_SECRET=a_key isaakiel/radon:latest`

There's a set of relevant environment variables that can or should be defined.

**required**

- *DB_HOST*: IP adress of the database container in the docker network
- *DB_PORT*: Port of the postgres server within the database container
- *DB_NAME*: Name of the radon database in the postgres containers postgres server
- *DB_USER*: Name of the user with access to the radon database within the postgres containers postgres server
- *DB_USER_PW*: Password of the user with access to the radon database within the postgres containers postgres server 

**optional**

- *RECAPTCHA_PRIVATE_KEY*
- *RECAPTCHA_PUBLIC_KEY*
- *TWITTER_ACCESS_TOKEN*
- *TWITTER_ACCESS_TOKEN_SECRET*
- *TWITTER_CONSUMER_KEY*
- *TWITTER_CONSUMER_SECRET*

## Submitting an Issue
We use the [GitHub issue tracker][issues] to track bugs and features. Before
submitting a bug report or feature request, check to make sure it hasn't
already been submitted. When submitting a bug report, please include a [Gist][]
that includes a stack trace and any details that may be necessary to reproduce
the bug, including your gem version, Ruby version, and operating system.
Ideally, a bug report should include a pull request with failing specs.

[gist]: https://gist.github.com/

## Submitting a Pull Request
1. [Fork the repository.][fork]
2. [Create a topic branch.][branch]
3. Add specs for your unimplemented feature or bug fix.
4. Run `bundle exec rake test`. If your specs pass, return to step 3.
5. Implement your feature or bug fix.
6. Run `bundle exec rake test`. If your specs fail, return to step 5.
7. Run `open coverage/index.html`. If your changes are not completely covered
   by your tests, return to step 3.
8. Add, commit, and push your changes.
9. [Submit a pull request.][pr]

[fork]: http://help.github.com/fork-a-repo/
[branch]: http://learn.github.com/p/branching.html
[pr]: http://help.github.com/send-pull-requests/

## Supported Ruby Version
This library aims to support and is [tested against][travis] Ruby version 2.3.1.

If something doesn't work on this version, it should be considered a bug.

This library may inadvertently work (or seem to work) on other Ruby
implementations, however support will only be provided for the version above.

If you would like this library to support another Ruby version, you may
volunteer to be a maintainer. Being a maintainer entails making sure all tests
run and pass on that implementation. When something breaks on your
implementation, you will be personally responsible for providing patches in a
timely fashion. If critical issues for a particular implementation exist at the
time of a major release, support for that Ruby version may be dropped.

[travis]: http://travis-ci.org/ISAAKiel/radon


## Copyright
Copyright (c) 2016 ISAAKiel. See [LICENSE][] for details.

[license]: https://github.com/ISAAKiel/radon/blob/master/LICENSE
