FROM webdevops/php-nginx:8.2

# تثبيت المكتبات المطلوبة
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    unzip \
    zip \
    git \
    curl \
    && docker-php-ext-install pdo pdo_mysql mbstring bcmath

# تحميل composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# تحديد مجلد العمل
WORKDIR /app

# نسخ الملفات
COPY . .

# تثبيت الاعتماديات
RUN composer install --no-dev --optimize-autoloader

# تخزين الكاش، لكن لا تشغل migrate هنا (سيفشل إن لم تكن قاعدة البيانات جاهزة)
RUN php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# فتح المنفذ 80
EXPOSE 80

# الأمر الافتراضي لتشغيل السيرفر
CMD ["supervisord"]
