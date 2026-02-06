FROM wordpress:php8.3-apache

# Install xdebug
RUN pecl install xdebug-3.1.5 && docker-php-ext-enable xdebug

# Install Less for WP-CLI
RUN apt-get update && apt-get -y install less

# Install WP-CLI
RUN curl -s -o /usr/local/bin/wp \
    https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

ARG server_user=dev
ARG server_user_pwd=dev

RUN useradd -ms /bin/bash $server_user
