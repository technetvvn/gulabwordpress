FROM wordpress:latest

# Fix tar permission error on Render disk mounts
RUN sed -i 's/| tar --extract --file - --directory/| tar --no-same-permissions --extract --file - --directory/g' /usr/local/bin/docker-entrypoint.sh

# Add persistent storage setup script
COPY wp-setup.sh /usr/local/bin/wp-setup.sh
RUN chmod +x /usr/local/bin/wp-setup.sh

ENTRYPOINT ["/usr/local/bin/wp-setup.sh"]
CMD ["apache2-foreground"]
