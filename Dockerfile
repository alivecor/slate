<<<<<<< HEAD
FROM ubuntu:16.04

WORKDIR /app

RUN \
  apt-get -y update && \
  apt-get -y install software-properties-common zlib1g-dev && \
  apt-add-repository ppa:brightbox/ruby-ng && \
  apt-get -y update && \
  apt-get -y install ruby2.4 ruby2.4-dev && \
  apt-get -y install -yq pkg-config build-essential nodejs git libxml2-dev libxslt-dev && \
  apt-get autoremove -yq

RUN gem2.4 install --no-ri --no-rdoc bundler

COPY Gemfile Gemfile
COPY gitconfig ~/.gitconfig

RUN \
  cd /app && \
  gem install sass -v '3.4.23' --source 'https://rubygems.org/' && \
  gem install nokogiri -v '1.8.4' --source 'https://rubygems.org/' && \
  bundle config build.nokogiri --use-system-libraries && \
  bundle install

#ENTRYPOINT ["bundle exec middleman server --watcher-force-polling --watcher-latency=1 &> ~/middleman.log &"]
=======
FROM ruby:2.6-slim

WORKDIR /srv/slate

VOLUME /srv/slate/build
VOLUME /srv/slate/source

EXPOSE 4567

COPY Gemfile .
COPY Gemfile.lock .

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        nodejs \
    && gem install bundler \
    && bundle install \
    && apt-get remove -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

COPY . /srv/slate

RUN chmod +x /srv/slate/slate.sh

ENTRYPOINT ["/srv/slate/slate.sh"]
CMD ["build"]
>>>>>>> slate/main
