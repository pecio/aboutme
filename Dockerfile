FROM alpine:3.11.6 AS builder

RUN /sbin/apk add --no-cache ruby ruby-bundler \
              ruby-dev make gcc libc-dev \
&&  /usr/sbin/addgroup -g 3000 ruby \
&&  /usr/sbin/adduser -s /bin/sh -G ruby -D -u 3000 rack

ENV GEM_HOME=/rack-app/gems

COPY --chown=rack:ruby Gemfile /rack-app/

WORKDIR /rack-app

USER rack

RUN /bin/sed -i.orig '/^[[:space:]]*ruby/d' Gemfile \
&&  /usr/bin/env DISABLE_SSL=true /usr/bin/bundle install \
                                  --without=development:test

FROM alpine:3.11.6 AS packager
COPY . /rack-app
COPY --from=builder /rack-app/gems /rack-app/gems

FROM alpine:3.11.6
LABEL mantainer="pedroche@me.com"

RUN /sbin/apk add --no-cache ruby ruby-bundler \
&&  /usr/sbin/addgroup -g 3000 ruby \
&&  /usr/sbin/adduser -s /bin/sh -G ruby -D -u 3000 rack

COPY --from=packager /rack-app /rack-app

WORKDIR /rack-app

ENV GEM_HOME=/rack-app/gems

USER rack

EXPOSE 3000

VOLUME /rack-app/public

ENTRYPOINT ["/rack-app/bin/runner"]
