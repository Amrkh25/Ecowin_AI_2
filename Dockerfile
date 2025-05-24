FROM webdevops/php-nginx:8.2

WORKDIR /app

COPY . /app
RUN docker-php-ext-install pdo pdo_mysql mbstring bcmath

RUN composer install --no-dev --optimize-autoloader
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache
RUN php artisan migrate --force

EXPOSE 80
