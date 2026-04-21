#!/bin/bash
set -e

PERSISTENT=/mnt/wp-content

# Setup symlink to persistent disk storage
if [ -d "$PERSISTENT" ]; then
    # Remove existing wp-content if not already a symlink
    if [ -e /var/www/html/wp-content ] && [ ! -L /var/www/html/wp-content ]; then
        rm -rf /var/www/html/wp-content
    fi
    # Create symlink pointing to persistent disk
    ln -sf "$PERSISTENT" /var/www/html/wp-content
fi

# Run original WordPress entrypoint
exec docker-entrypoint.sh "$@"
