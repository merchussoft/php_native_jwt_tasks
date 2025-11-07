FROM php:8.2-apache

WORKDIR /var/www


## Instalar dependencias
RUN apt update && apt dist-upgrade -y && apt update

RUN apt install unzip curl libpng-dev libjpeg-dev libfreetype6-dev

# Extensiones de php (pdo_mysql y gb)
RUN docker-php-ext-install pdo pdo_mysql gd


# Instalar Composer globalmente 
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Copiar codigo al contenedor
COPY . .

# Instalar dependencias PHP automáticamente
RUN composer install --no-interaction --prefer-dist

# Exponer puerto
EXPOSE 80