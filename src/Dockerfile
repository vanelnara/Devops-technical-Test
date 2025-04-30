FROM php:8.2-fpm-alpine
RUN apk add --no-cache nginx mysql-client && docker-php-ext-install pdo_mysql
COPY src/php/ /var/www/html/
COPY src/nginx/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
CMD sh -c "php-fpm -D && nginx -g 'daemon off;'"
