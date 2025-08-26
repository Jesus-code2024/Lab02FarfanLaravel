# Imagen base de PHP con Composer
FROM php:8.2-cli

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configurar directorio de trabajo
WORKDIR /app

# Copiar archivos del proyecto
COPY . .

# Copiar .env.example como .env
RUN cp .env.example .env

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Generar clave de la aplicación
RUN php artisan key:generate

# Exponer el puerto
EXPOSE 8000

# Comando para arrancar Laravel
CMD php artisan serve --host=0.0.0.0 --port=8000
