FROM dwchiang/nginx-php-fpm:8.1.25-fpm-bullseye-nginx-1.24.0
# FROM dwchiang/nginx-php-fpm:8.3.3-fpm-bullseye-nginx-1.24.0

ENV PHP_OPCACHE_VALIDATE_TIMESTAMPS="1" \
    PHP_OPCACHE_MAX_ACCELERATED_FILES="10000" \
    PHP_OPCACHE_MEMORY_CONSUMPTION="192" \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE="10"


# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libwebp-dev \
    libxpm-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libzip-dev libonig-dev\
    libcurl4-openssl-dev pkg-config libssl-dev

RUN apt-get update && apt-get install -y \
        zlib1g-dev
#RUN pecl install mongodb \
#&& echo "extension=mongodb.so" > $PHP_INI_DIR/conf.d/mongo.ini    
# Install kafka
#RUN apt install -y librdkafka-dev
#RUN pecl install rdkafka
#RUN docker-php-ext-enable rdkafka    

# RUN pecl install mongodb \
#     && echo "extension=mongodb.so" > $PHP_INI_DIR/conf.d/mongo.ini

RUN pecl install redis && docker-php-ext-enable redis

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN apt-get update && apt-get install -y libpq-dev \
    && docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl pdo_pgsql
#RUN docker-php-ext-configure gd --with-freetype 
#RUN docker-php-ext-configure gd --with-png=/usr/include/ --with-jpeg=/usr/include/ --with-freetype=/usr/include/
#RUN docker-php-ext-install gd

# Install intl exetnsion - to use NumberFormatter class
RUN apt-get update
RUN apt-get install -y zlib1g-dev libicu-dev g++
#RUN docker-php-ext-configure intl
#RUN docker-php-ext-install intl calendar

# Add user for laravel application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

COPY . /var/www/html/
COPY .local/docker-entrypoint.d/ /docker-entrypoint.d
RUN find /docker-entrypoint.d/ -type f -exec chmod +x {} \;
COPY public/ /usr/share/nginx/html
COPY public/ /var/www/html/public

RUN set -x && \
    touch /var/www/html/storage/logs/laravel.log && \
    touch /var/log/cron.log && \
    chown -R www-data:www-data /usr/share/nginx/html && \
    chown -R www-data:www-data /var/www/html && \
    find /var/www/html/storage -type f -exec chmod 664 {} \; && \
    find /var/www/html/storage -type d -exec chmod 770 {} \;

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer clearcache
RUN rm -rf vendor/*
RUN composer install --no-scripts
RUN docker-php-ext-install opcache

#COPY .local/php/qa-supervisor.conf /etc/supervisor/conf.d/bookingapi.conf
COPY .local/php/qa.ini $PHP_INI_DIR/conf.d/bookingapi.ini
COPY .local/nginx /etc/nginx/conf.d
COPY .local/opcache/opcache.ini /usr/local/etc/php/conf.d/opcache.ini


EXPOSE 80
