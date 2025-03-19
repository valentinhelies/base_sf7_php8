FROM php:8.4.5-apache

RUN a2enmod rewrite

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        locales apt-utils git libicu-dev g++ libpng-dev libxml2-dev libzip-dev libonig-dev libxslt-dev unzip \
        libpq-dev nodejs npm wget apt-transport-https lsb-release ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen  \
    &&  echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen \
    &&  locale-gen

RUN docker-php-ext-configure intl
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql opcache intl zip calendar dom mbstring gd xsl;

RUN pecl install apcu && docker-php-ext-enable apcu

RUN curl -sS https://getcomposer.org/installer | php -- \
    &&  mv composer.phar /usr/local/bin/composer

RUN git config --global user.email "example@email.com" \
    &&  git config --global user.name "YOUR NAME"

COPY ./docker/apache/default.conf /etc/apache2/sites-enabled/000-default.conf
COPY ./docker/php/php.ini /usr/local/etc/php/

COPY . /var/www/html/
WORKDIR /var/www/html

RUN COMPOSER_MEMORY_LIMIT=-1 composer install

RUN npm install --global yarn

VOLUME ["/var/www/html/var/cache"]

EXPOSE 80

CMD ["apache2-foreground"]
