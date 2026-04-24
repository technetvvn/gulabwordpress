#!/bin/bash
set -e

PERSISTENT=/mnt/wp-content

# 1. Remove Redis cache
rm -f "$PERSISTENT/object-cache.php" 2>/dev/null || true

# 2. Run WordPress entrypoint first
docker-entrypoint.sh apache2-foreground &
APACHE_PID=$!

# Wait for WordPress to finish setup
sleep 15

# 3. Fix wp-content symlink
if [ -d "$PERSISTENT" ] && [ ! -L /var/www/html/wp-content ]; then
    cp -rn /var/www/html/wp-content/* "$PERSISTENT/" 2>/dev/null || true
    rm -rf /var/www/html/wp-content
    ln -sf "$PERSISTENT" /var/www/html/wp-content
fi

# 4. Fix filesystem method (no FTP prompts)
grep -q "FS_METHOD" /var/www/html/wp-config.php || \
    sed -i "s/<?php/<?php\ndefine('FS_METHOD', 'direct');/" /var/www/html/wp-config.php

# 5. Fix site URLs
grep -q "WP_HOME" /var/www/html/wp-config.php || \
    sed -i "s/<?php/<?php\ndefine('WP_HOME','https:\/\/aeoc.in');\ndefine('WP_SITEURL','https:\/\/aeoc.in');/" \
    /var/www/html/wp-config.php

# 6. Remove Redis cache file again (safety)
rm -f /var/www/html/wp-content/object-cache.php 2>/dev/null || true
rm -f /mnt/wp-content/object-cache.php 2>/dev/null || true

# 7. Fix permissions
chown -R www-data:www-data /var/www/html/ 2>/dev/null || true
chown -R www-data:www-data /mnt/wp-content/ 2>/dev/null || true

echo "✅ WordPress setup complete!"

# Wait for Apache
wait $APACHE_PID
