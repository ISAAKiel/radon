# taken from https://github.com/mookjp/rails-docker-example

FROM ruby:2.3.5-jessie
MAINTAINER Martin Hinz <martin.hinz@ufg.uni-kiel.de>

# Define user option arguments
ARG rprk
ARG rpuk
ARG tat
ARG tats
ARG tck
ARG tcs
ARG dbh
ARG dbp
ARG dbn
ARG dbu
ARG dbup

# Define environment variables
ENV RECAPTCHA_PRIVATE_KEY=$rprk
ENV RECAPTCHA_PUBLIC_KEY=$rpuk
ENV TWITTER_ACCESS_TOKEN=$tat
ENV TWITTER_ACCESS_TOKEN_SECRET=$tats
ENV TWITTER_CONSUMER_KEY=$tck
ENV TWITTER_CONSUMER_SECRET=$tcs
ENV DB_HOST=$dbh
ENV DB_PORT=$dbp
ENV DB_NAME=$dbn
ENV DB_USER=$dbu
ENV DB_USER_PW=$dbup

# Install nginx with passenger
RUN gem install passenger -v 5.0.4 && \
    apt-get update && \
    apt-get install -y libcurl4-openssl-dev && \
		apt-get install -y qt4-default && \
		apt-get install -y libqtwebkit-dev && \
    passenger-install-nginx-module --auto

ADD docker/rails/conf/nginx.conf /opt/nginx/conf/nginx.conf

# Add configuration to set daemon mode off
RUN echo "daemon off;" >> /opt/nginx/conf/nginx.conf

# Install Rails dependencies
RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN bundle install --system

ADD . /usr/src/app

# Initialize log
RUN cat /dev/null > /usr/src/app/log/production.log
RUN chmod -R a+w /usr/src/app/log

EXPOSE 80

ENV RAILS_ENV=production

ADD docker/rails/start.sh /usr/src/app/
RUN chmod +x /usr/src/app/start.sh
WORKDIR /usr/src/app/
CMD ["./start.sh"]