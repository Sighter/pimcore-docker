FROM chialab/php:7.1-apache
COPY index.php /var/www/html/
RUN docker-php-ext-install exif

ENV APACHE_DOCUMENT_ROOT /pimcore-install/web

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY pimcore-install /pimcore-install
COPY pimcore-install-substitutions/ /pimcore-install-substitutions/
COPY pimcore-install-substitutions/composer.json /pimcore-install/composer.json

RUN chown -R www-data:www-data \
    /pimcore-install/web/var \
    /pimcore-install/var \
    /pimcore-install/pimcore \
    /pimcore-install/app \
    /pimcore-install/src
CMD cd /pimcore-install \
  && su www-data -s /bin/bash -c \
  "bin/install --profile empty \
  --admin-username admin --admin-password admin \
  --mysql-username root --mysql-password testing --mysql-database pimcoredb \
  --mysql-host-socket pimcore-mariadb \
  --no-interaction" \
  && composer require coreshop/core-shop dev-master \
  && chown -R www-data:www-data var \
  && su www-data -s /bin/bash -c \
  "cp /pimcore-install-substitutions/app/AppKernel.php /pimcore-install/app/AppKernel.php \
   && cp /pimcore-install-substitutions/app/config/config.yml /pimcore-install/app/config/config.yml" \
  && php bin/console coreshop:install \
  && apache2-foreground

