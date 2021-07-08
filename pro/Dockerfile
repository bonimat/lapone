# php-fpm and apache 2.4
FROM webdevops/php-apache:7.4

# php library
RUN apt-get update && apt-get install -y \
    git \
    libzip-dev \
    libpq-dev \
    zip \
    && rm -rf /var/lib/apt/lists/* \
    && a2enmod rewrite \
    && docker-php-ext-install zip intl pdo pdo_pgsql

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