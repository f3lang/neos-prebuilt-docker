FROM ubuntu:xenial

RUN apt-get update && apt-get install -y software-properties-common
RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" >> /etc/apt/sources.list.d/ondrej-php7.list
RUN echo "deb-src http://ppa.launchpad.net/ondrej/php/ubuntu xenial main" >> /etc/apt/sources.list.d/ondrej-php7.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C
RUN apt-get update && apt-get install -y apache2 php7.2 php7.2-mbstring php7.2-redis libapache2-mod-php7.2 php7.2-imagick php7.2-xml php7.2-mysql curl git zip unzip
RUN a2enmod rewrite && rm -r /var/www/html
COPY ./config/etc/apache2/apache2.conf /etc/apache2/apache2.conf

RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

RUN mkdir /neos && chown www-data:www-data /neos && chown www-data:www-data /var/www

USER www-data
RUN cd /neos && composer create-project --no-dev neos/neos-base-distribution ./ && \
    ln -s /neos/Web /var/www/html
