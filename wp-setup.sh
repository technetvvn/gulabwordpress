#!/bin/bash
set -e

PERSISTENT=/mnt/wp-content

# Remove Redis object cache
rm -f "$PERSISTENT/object-cache.php" 2>/dev/null || true

# Run original WordPress entrypoint first
# This lets WordPress copy files and create wp-config.php
docker-entrypoint.sh apache2-foreground &
APACHE_PID=$!

# Wait for WordPress to finish initial setup (copy files etc)
sleep 10

# NOW fix symlink AFTER WordPress has done its thing
if [ -d "$PERSISTENT" ] && [ ! -L /var/www/html/wp-content ]; then
    # Copy any new WordPress files to persistent disk
    cp -rn /var/www/html/wp-content/* "$PERSISTENT/" 2>/dev/null || true
    rm -rf /var/www/html/wp-content
    ln -sf "$PERSISTENT" /var/www/html/wp-content
fi

# Wait for Apache to keep running
wait $APACHE_PID
