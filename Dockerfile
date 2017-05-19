FROM php:7.1.5-fpm-alpine

VOLUME /var/www/html
WORKDIR /var/www/html

ENV DEBUG_IP 10.0.75.1

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql

#RUN docker-php-ext-install xdebug-2.5.0 && docker-php-ext-enable xdebug

COPY php.ini /etc/php7/conf.d/50-setting.ini
COPY php-fpm.conf /etc/php7/php-fpm.conf


RUN apk add --no-cache autoconf file g++ gcc libc-dev make pkgconf re2c
RUN pecl install xdebug
RUN apk del autoconf file g++ gcc libc-dev make pkgconf re2c

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

	
COPY entrypoint /usr/local/bin/entrypoint
RUN chmod 777 /usr/local/bin/entrypoint
	
EXPOSE 9000
ENTRYPOINT ["entrypoint"]