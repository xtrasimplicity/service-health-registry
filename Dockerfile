FROM ruby:2.6-alpine
WORKDIR /app
RUN gem install bundler

COPY Gemfile* /app/
RUN bundle install --without test

COPY . /app

EXPOSE 4567

CMD ["/usr/bin/env", "ruby", "/app/server.rb"]