FROM ruby:2.6-alpine

RUN apk add --no-cache g++ make && \
    gem install bundler

WORKDIR /app

COPY Gemfile* /app/
RUN bundle install --without test

COPY . /app

EXPOSE 4567

CMD ["/usr/bin/env", "ruby", "/app/server.rb"]