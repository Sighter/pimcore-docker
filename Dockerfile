FROM chialab/php:7.1-apache
#COPY php.ini /usr/local/etc/php/
COPY index.php /var/www/html/
RUN docker-php-ext-install exif

ENV APACHE_DOCUMENT_ROOT /pimcore-install/web

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# RUN docker-php-ext-install mysqli
# RUN pecl install intl \
#     && docker-php-ext-enable intl
COPY pimcore-install /pimcore-install
RUN chown -R www-data:www-data \
    /pimcore-install/web/var \
    /pimcore-install/var \
    /pimcore-install/pimcore \
    /pimcore-install/app \
    /pimcore-install/src
CMD cd /pimcore-install \
  && composer require coreshop/core-shop dev-master --no-scripts \
  && su www-data -s /bin/bash -c \
  "bin/install --profile empty \
  --admin-username admin --admin-password admin \
  --mysql-username root --mysql-password testing --mysql-database pimcoredb \
  --mysql-host-socket pimcore-mariadb \
  --no-interaction" \
  && su www-data -s /bin/bash -c \
  "php bin/console coreshop:install" \
  && apache2-foreground

