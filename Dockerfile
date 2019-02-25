FROM php:7.1.5-fpm-alpine

VOLUME /var/www/html
WORKDIR /var/www/html

ENV DEBUG_IP 10.0.75.1

RUN apk add --no-cache --update autoconf file g++ gcc libc-dev make pkgconf re2c libxml2-dev libpng-dev

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli 

RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql 

RUN docker-php-ext-install gd && docker-php-ext-enable gd 

RUN docker-php-ext-configure zip
RUN docker-php-ext-install zip

RUN pecl install xdebug

RUN apk del autoconf file g++ gcc libc-dev make pkgconf re2c libxml2-dev

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

	
COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY php-fpm.conf /etc/php7/php-fpm.conf	
	
COPY entrypoint /usr/local/bin/entrypoint
RUN chmod 777 /usr/local/bin/entrypoint
	
EXPOSE 9000
ENTRYPOINT ["entrypoint"]