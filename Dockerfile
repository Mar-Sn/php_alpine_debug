FROM php:7.1.11-fpm-alpine

#The location of the files that need to be accessed by PHP
VOLUME /var/www/html/

#the location where the unix socks will be created
VOLUME /var/lib/php7/

#the config files
#VOLUME /usr/local/etc/php-fpm.d
VOLUME /usr/local/etc/configfiles
VOLUME /usr/local/etc/config

#Setting the working directory
WORKDIR /var/www/html

ENV DEBUG_IP 10.0.75.1

# Updating repo
RUN apk apk update

# Installing
# Dependencies for PHP extensions
RUN apk add --no-cache --update freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev libedit-dev libxml2-dev curl-dev
# Dependencies for compile gd
RUN apk add --no-cache --update m4 perl autoconf libmagic file libgcc libstdc++ binutils-libs binutils gmp libgomp libatomic mpfr3 gcc musl-dev libc-dev g++ make re2c libmcrypt-dev icu-dev libxslt-dev

# Compiling gd
RUN docker-php-ext-configure gd \
    --with-gd \
    --with-freetype-dir=/usr/include/ \
    --with-png-dir=/usr/include/ \
    --with-jpeg-dir=/usr/include/

# Installing PHP extensions
RUN docker-php-ext-install \
gd iconv opcache readline soap xml mysqli curl json mcrypt curl mbstring zip pdo_mysql intl xsl

RUN docker-php-ext-enable \
gd iconv opcache readline soap xml mysqli curl json mcrypt curl mbstring zip pdo_mysql intl xsl

RUN apk del m4 perl autoconf libmagic file libgcc libstdc++ binutils-libs binutils gmp libgomp libatomic mpfr3 gcc musl-dev libc-dev g++ make re2c

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

COPY php.1.ini /usr/local/etc/php/conf.d/php.ini
COPY php.ini /usr/local/etc/php-fpm.conf
	
COPY entrypoint /usr/local/bin/entrypoint
RUN chmod 777 /usr/local/bin/entrypoint
	
EXPOSE 9000
ENTRYPOINT ["entrypoint"]