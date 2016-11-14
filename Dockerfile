FROM php:5.6-cli

MAINTAINER Dmitry Seleznyov <selim013@gmail.com>

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        bash-completion \
        ca-certificates \
        git \
        less \
        locales \
        ssh \
        tmux \
        vim \
        wget

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

# Tiny
# Add Tini
#ENV TINI_VERSION v0.13.0
#RUN curl -o /usr/local/bin/tini -fSL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
#    && chmod +x /usr/local/bin/tini

# GOSU
ENV GOSU_VERSION 1.10
RUN set -x \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true

# Composer
ENV COMPOSER_HOME /composer
ENV PATH /composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_VERSION 1.2.2

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
    && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} \
    && rm -rf /tmp/composer-setup.php

# PHPUnit
ENV PHPUNIT_VERSION 5.6.2
ENV PHPUNIT_URL "https://phar.phpunit.de/phpunit-$PHPUNIT_VERSION.phar"
ENV PHPUNIT_SHA256 "6de0442d0c731d7aba478f6fc3879c27b00f5b4c8ef7bcd812d8f7d442f9aa37"

RUN curl -o /usr/local/bin/phpunit -fSL $PHPUNIT_URL \
    && echo "${PHPUNIT_SHA256}  /usr/local/bin/phpunit" | sha256sum -c - \
    && chmod +x /usr/local/bin/phpunit

# Setup user
# Specify any standard chown format (uid, uid:gid)
ENV GOSU_USER 1000:1000
ENV GOSU_CHOWN /home/developer

RUN mkdir /home/developer \
    && groupadd developer \
    && useradd -s /bin/bash -u 1000 -g developer -G www-data developer

# Terminal
ENV TERM screen-256color

COPY custom.bash /etc/custom.bash
RUN echo "source /etc/custom.bash" >> /etc/bash.bashrc

#COPY tmux.conf /home/developer/.tmux.conf
#
#RUN git clone https://github.com/erikw/tmux-powerline.git /usr/lib/tmux-powerline \
#    && git clone https://github.com/tmux-plugins/tmux-yank.git /home/developer/.tmux/tmux-yank

# Create dirs at home and fix permissions
RUN mkdir /home/developer/.ssh \
    && chmod 700 /home/developer/.ssh \
    && chown -R developer:developer /home/developer

COPY entrypoint.sh /usr/local/bin/

#ENTRYPOINT ["tini", "--", "entrypoint.sh"]
#CMD ["tmux", "new", "-s", "main", "bash"]

ENTRYPOINT ["entrypoint.sh"]