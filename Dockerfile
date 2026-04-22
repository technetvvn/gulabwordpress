FROM wordpress:latest

# PHP settings
RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/custom.ini \
    && echo "max_execution_time = 600" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "max_input_time = 600" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "max_input_vars = 10000" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "post_max_size = 128M" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "upload_max_filesize = 64M" >> /usr/local/etc/php/conf.d/custom.ini

# Patch wp-config-docker.php at BUILD TIME — permanent fix!
RUN sed -i "s/\$table_prefix = getenv_docker('WORDPRESS_TABLE_PREFIX', 'wp_');/\$table_prefix = 'a6_';/" \
    /usr/src/wordpress/wp-config-docker.php

COPY wp-setup.sh /usr/local/bin/wp-setup.sh
RUN chmod +x /usr/local/bin/wp-setup.sh

ENTRYPOINT ["/usr/local/bin/wp-setup.sh"]
CMD ["apache2-foreground"]
