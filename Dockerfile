FROM php:8.2

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# تثبيت بعض المتطلبات
RUN apt-get update && apt-get install -y \
    zip unzip libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip

# نسخ ملفات المشروع
WORKDIR /var/www
COPY . .

# تثبيت الباكجات
RUN composer install --no-dev --optimize-autoloader

# تخزين الكاش والمهاجرات
RUN php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# تشغيل التطبيق
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8080"]
