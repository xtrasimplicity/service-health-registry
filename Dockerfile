FROM ruby:2.6-alpine

RUN apk add --no-cache g++ make mariadb-dev mariadb-client && \
    gem install bundler && \
    addgroup registry && \
    adduser --disabled-password --ingroup registry \
            -h /app registry

WORKDIR /app
USER registry

ENV GEM_HOME /app/vendor/bundle
ENV GEM_PATH "${GEM_HOME}:/usr/local/bundle"
ENV BUNDLE_APP_CONFIG "${GEM_HOME}"

COPY --chown=registry:registry Gemfile* /app/
RUN bundle config set without 'test:development' && \
    bundle install

COPY --chown=registry:registry . /app

EXPOSE 4567

CMD ["/usr/bin/env", "ruby", "/app/application.rb", "-s puma"]