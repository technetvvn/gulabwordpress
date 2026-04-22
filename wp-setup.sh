#!/bin/bash
set -e

PERSISTENT=/mnt/wp-content

# Setup symlink to persistent disk storage
if [ -d "$PERSISTENT" ]; then
    if [ -e /var/www/html/wp-content ] && [ ! -L /var/www/html/wp-content ]; then
        rm -rf /var/www/html/wp-content
    fi
    ln -sf "$PERSISTENT" /var/www/html/wp-content
fi

# Fix table prefix permanently
sed -i "s/\$table_prefix = getenv_docker('WORDPRESS_TABLE_PREFIX', 'wp_');/\$table_prefix = 'a6_';/" /var/www/html/wp-config.php 2>/dev/null || true
sed -i "/getenv_docker('WORDPRESS_TABLE_PREFIX'/d" /var/www/html/wp-config.php 2>/dev/null || true

# Remove Redis object cache if exists
rm -f /mnt/wp-content/object-cache.php

# Run original WordPress entrypoint
exec docker-entrypoint.sh "$@"
