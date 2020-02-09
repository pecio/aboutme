FROM alpine
MAINTAINER "Raúl Pedroche"

RUN apk add --no-cache ruby ruby-bundler \
        ruby-json ruby-dev make gcc libc-dev \
&&  /usr/sbin/addgroup ruby \
&&  /usr/sbin/adduser -s /bin/sh -G ruby -D rack

ADD . /rack-app

RUN /bin/chown -R rack:ruby /rack-app

WORKDIR /rack-app

USER rack

ENV GEM_HOME=/rack-app/gems

# Set .env-prod as .env
# Remove Ruby version tag
# Remove installed gems from Gemfile and Gemfile.lock
RUN /bin/mv -f /rack-app/.env-prod /rack-app/.env \
&&  /bin/sed -i.orig '/^[[:space:]]*ruby/d' Gemfile \
&&  for G in $(gem list --local --no-versions | grep -v LOCAL); do \
      /bin/sed -i "/[\"']$G[\"']/d" Gemfile &&\
      /bin/sed -i -e "/^[[:space:]]*$G[[:space:]]/d" \
                  -e "/^[[:space:]]*$G\$/d" Gemfile.lock; \
    done \
&&  /bin/sed -i "/BUNDLED WITH/,+1d" Gemfile.lock \
&&  DISABLE_SSL=true /usr/bin/bundle install \
                     --without=development:test

EXPOSE 3000

VOLUME /rack-app/public

ENTRYPOINT ["/rack-app/bin/runner"]
