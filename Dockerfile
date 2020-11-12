FROM alpine:3.12.0 AS base

RUN /usr/sbin/addgroup -g 3000 ruby \
&&  /usr/sbin/adduser -s /bin/sh -G ruby -D -u 3000 rack

ENV GEM_HOME=/rack-app/gems

#---
FROM base AS builder

RUN /sbin/apk add --no-cache ruby ruby-bundler \
              ruby-dev make gcc libc-dev

COPY --chown=rack:ruby Gemfile /rack-app/

WORKDIR /rack-app

USER rack

RUN /bin/sed -i.orig \
             -e '/^[[:space:]]*ruby/d' \
             -e '/google-cloud/d' \
             Gemfile \
&&  /usr/bin/bundle install --without=development:test

#---
FROM base AS packager

COPY --chown=rack:ruby . /rack-app
COPY --from=builder /rack-app/gems /rack-app/gems

#---
FROM base
LABEL mantainer="pedroche@me.com"

RUN /sbin/apk add --no-cache ruby ruby-bundler

COPY --from=packager /rack-app /rack-app

WORKDIR /rack-app

USER rack

EXPOSE 3000

VOLUME /rack-app/public

ENV RACK_ENV=production PORT=3000

ENTRYPOINT ["/rack-app/bin/runner"]
