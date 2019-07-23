FROM ruby:2.6-alpine

RUN apk add --no-cache g++ make mariadb-dev mariadb-client && \
    gem install bundler

WORKDIR /app

COPY Gemfile* /app/
RUN bundle install --without test,development

COPY . /app

EXPOSE 4567

CMD ["/usr/bin/env", "ruby", "/app/application.rb", "-s puma"]