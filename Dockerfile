# php-fpm and apache 2.4
FROM webdevops/php-apache:8.0

# xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo -e "xdebug.mode=debug\n\
    xdebug.start_with_request=yes\n\
    xdebug.idekey=PHPSTORM\n\
    xdebug.discover_client_host=true\n\
    xdebug.client_host=172.18.0.1\n\
    xdebug.client_port=9004\n\
    xdebug.log=/tmp/xdebug.log\n">>/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini


# php library
RUN apt-get update && apt-get install -y \
    git \
    libapache2-mod-shib2 \
    libzip-dev \
    libpq-dev \
    zip \
    && rm -rf /var/lib/apt/lists/* \
    && a2enmod rewrite \
    && docker-php-ext-install zip intl pdo pdo_pgsql 

# phpunit
RUN curl -L -o /usr/local/bin/phpunit https://phar.phpunit.de/phpunit-9.5.phar
RUN chmod +x /usr/local/bin/phpunit

# composer
RUN curl -sL https://getcomposer.org/installer | php -- --install-dir /usr/bin --filename composer

# Change DocumentRoot
WORKDIR /app

# Change uid & gid of www-data
RUN usermod -o -u 1000 www-data && groupmod -o -g 1000 www-data

# Change TimeZone and Locale
ENV TZ=Europe/Rome
ENV LANG it_IT.UTF-8
ENV LANGUAGE it_IT.UTF-8
ENV LC_ALL it_IT.UTF-8
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN date
