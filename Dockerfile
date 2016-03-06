FROM alpine
MAINTAINER "Raúl Pedroche"

RUN apk add --no-cache ruby ruby-bundler \
        ruby-io-console ruby-i18n ruby-mail \
        ruby-tilt ruby-json ruby-rack ruby-dev \
        make gcc libc-dev
RUN /usr/sbin/addgroup ruby
RUN /usr/sbin/adduser -s /bin/ash -G ruby -D rack

ADD . /rack-app

RUN /bin/chown -R rack:ruby /rack-app

WORKDIR /rack-app

USER rack

ENV GEM_HOME "/rack-app/gems"
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/rack-app/gems/bin"
ENV DISABLE_SSL true

RUN /bin/mv -f /rack-app/.env-prod /rack-app/.env
RUN /bin/sed -i.orig '/^[[:space:]]*ruby/d' Gemfile

# Remove installed gems from Gemfile and Gemfile.lock
RUN for G in $(gem list --local --no-versions | grep -v LOCAL); do \
      sed -i "/[\"']$G[\"']/d" Gemfile &&\
      sed -i -e "/^[[:space:]]*$G[[:space:]]/d" \
             -e "/^[[:space:]]*$G\$/d" Gemfile.lock; \
    done

RUN /usr/bin/bundle install --without=development:test

EXPOSE 3000

ENTRYPOINT ["/rack-app/bin/runner"]
