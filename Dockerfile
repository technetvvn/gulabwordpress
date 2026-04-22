FROM wordpress:latest

RUN echo "memory_limit = 512M" > /usr/local/etc/php/conf.d/custom.ini \
    && echo "max_execution_time = 600" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "max_input_time = 600" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "max_input_vars = 10000" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "post_max_size = 128M" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "upload_max_filesize = 64M" >> /usr/local/etc/php/conf.d/custom.ini

COPY wp-setup.sh /usr/local/bin/wp-setup.sh
RUN chmod +x /usr/local/bin/wp-setup.sh

ENTRYPOINT ["/usr/local/bin/wp-setup.sh"]
CMD ["apache2-foreground"]
