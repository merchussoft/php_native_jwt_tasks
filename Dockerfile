FROM php:8.2-apache

WORKDIR /var/www/html



## Instalar dependencias
RUN apt update && apt dist-upgrade -y && apt install -y \
    unzip curl git libpng-dev libjpeg-dev libfreetype6-dev \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql gd

# Habilitar mod_rewrite para URLs amigables
RUN a2enmod rewrite

# 👉 Configurar Apache para que DocumentRoot sea /public
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf \
 && sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/apache2.conf

# Configurar Apache para permitir .htaccess
RUN sed -i 's|AllowOverride None|AllowOverride All|g' /etc/apache2/apache2.conf


# Instalar Composer globalmente 
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Copiar codigo al contenedor
COPY . .

# Instalar dependencias PHP automáticamente
RUN composer install --no-interaction --prefer-dist || true

# Dar permisos correctos
RUN chown -R www-data:www-data /var/www/html

# Exponer puerto
EXPOSE 80