FROM php:8.3-cli-alpine3.20

RUN apk add --no-cache  \
    autoconf \
    brotli-dev \
    curl  \
    gcc \
    git  \
    g++ \
    libcurl \
    libtool \
    make \
    mysql-client \
    openssl-dev \
    pkgconf \
    unzip  \
    zip  \
    && docker-php-ext-install pdo_mysql pcntl  \
    && pecl install swoole \
    && docker-php-ext-enable swoole

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

COPY . /app

ARG APP_ENV

RUN if [ "$APP_ENV" = "local" ] || [ "$APP_ENV" = "dev" ]; then \
    composer install --no-interaction --prefer-dist --optimize-autoloader --dev; \
    else \
    composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev; \
    fi

EXPOSE 8000

CMD ["php", "artisan", "octane:start", "--host=0.0.0.0", "--port=8000"]
