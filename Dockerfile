FROM php:7.4-fpm-alpine

VOLUME /var/www/html
WORKDIR /var/www/html

ENV DEBUG_IP 127.0.0.1
ENV OPCACHE true

RUN apk add --no-cache --update autoconf file g++ gcc libzip libzip-dev libc-dev make pkgconf re2c libxml2-dev libpng-dev freetype-dev libjpeg-turbo-dev libpng-dev

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli 

RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql 

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd && docker-php-ext-enable gd 

RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip

RUN docker-php-ext-install opcache && docker-php-ext-enable opcache 

RUN pecl install xdebug

RUN apk del autoconf file g++ gcc libc-dev make pkgconf re2c libxml2-dev libzip libzip-dev

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

	
COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY php-fpm.conf /etc/php7/php-fpm.conf	
	
COPY entrypoint /usr/local/bin/entrypoint
RUN chmod 777 /usr/local/bin/entrypoint
	
EXPOSE 9000
ENTRYPOINT ["entrypoint"]