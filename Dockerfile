FROM alpine

RUN apk add --no-cache ruby ruby-bundler ruby-unicorn ruby-io-console ruby-i18n ruby-mail ruby-tilt ruby-json
RUN /usr/sbin/addgroup ruby
RUN /usr/sbin/adduser -s /bin/ash -G ruby -D rack

ADD . /rack-app

RUN /bin/chown -R rack:ruby /rack-app

WORKDIR /rack-app

USER rack

ENV GEM_HOME "/rack-app/gems"
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/rack-app/gems/bin"
ENV RACK_ENV "production"

RUN /bin/rm -f .rvmrc .versions.conf .ruby-version
RUN /bin/sed -i.orig '/^[[:space:]]*ruby/d' Gemfile
RUN /bin/sed -i '/unicorn/d' Gemfile
RUN /bin/sed -i '/i18n/d' Gemfile
RUN /bin/sed -i '/mail/d' Gemfile
RUN /bin/sed -i '/rack[^-]/d' Gemfile
RUN /bin/sed -i.orig '/^[[:space:]]*unicorn/d' Gemfile.lock
RUN /bin/sed -i '/^[[:space:]]*kgio/d' Gemfile.lock
RUN /bin/sed -i '/^[[:space:]]*raindrops/d' Gemfile.lock
RUN /bin/sed -i '/^[[:space:]]*i18n/d' Gemfile.lock
RUN /bin/sed -i '/^[[:space:]]*mail/d' Gemfile.lock
RUN /bin/sed -i '/^[[:space:]]*mime-types/d' Gemfile.lock
RUN /bin/sed -i '/^[[:space:]]*tilt/d' Gemfile.lock
RUN /bin/sed -i -e '/^[[:space:]]*rack[[:space:]]/d' -e '/^[[:space:]]*rack$/d' Gemfile.lock
RUN /bin/mkdir /rack-app/gems
RUN /usr/bin/bundle install --without=development:test

EXPOSE 8080

ENTRYPOINT ["/usr/bin/unicorn"]
