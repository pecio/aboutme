FROM ubuntu

RUN apt-get update &&\
    apt-get upgrade -qy &&\
    apt-get install -qy curl build-essential openssl libreadline6-dev \
      zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 \
      libxslt-dev autoconf libc6-dev ncurses-dev automake libtool \
      bison subversion pkg-config gawk libgdbm-dev libffi-dev \
      libxml2-dev &&\
    echo "/bin/ln -sf /proc/self/fd /dev/fd" > /etc/profile.d/devfd.sh &&\
    chmod 0755 /etc/profile.d/devfd.sh &&\
    /bin/bash -c -l 'curl -sSL https://get.rvm.io | bash -s stable --ruby' &&\
    /bin/rm -f /etc/profile.d/devfd.sh &&\
    /usr/sbin/useradd -m -s /bin/bash -g rvm rack

ADD . /rack-app

RUN /bin/chown -R rack:rvm /rack-app

WORKDIR /rack-app

USER rack

RUN /bin/rm -f .rvmrc .versions.conf .ruby-version &&\
    /bin/sed -i.orig '/^[[:space:]]*ruby/d' Gemfile &&\
    /bin/bash -c -l 'gem install bundler --no-ri --no-rdoc' &&\
    /bin/bash -c -l 'bundle install --without=development:test'

EXPOSE 8080

CMD ['/bin/bash', '-c', '-l', 'bundle exec unicorn']
