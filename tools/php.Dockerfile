FROM php:8-apache

# copy src files from the host to the containers working dir
COPY src /var/www/
RUN chown -R www-data:www-data /var/www

# start the server
CMD [ "apache2-foreground"]