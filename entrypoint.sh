#!/bin/bash
set -e

# Railway Port (default 8069 if not set)
export HTTP_PORT=${PORT:-8069}

# PostgreSQL Connection
export DB_HOST=${PGHOST:-localhost}
export DB_PORT=${PGPORT:-5432}
export DB_USER=${PGUSER:-odoo}
export DB_PASSWORD=${PGPASSWORD:-odoo}

# Admin Password
export ODOO_ADMIN_PASSWD=${ADMIN_PASSWD:-admin}

echo "Starting Odoo on port ${HTTP_PORT}..."
echo "Database: ${DB_USER}@${DB_HOST}:${DB_PORT}"

# Start Odoo mit Command-Line Argumenten (statt Config-Datei für sensitive Werte)
exec odoo \
    --http-port=${HTTP_PORT} \
    --http-interface=0.0.0.0 \
    --db_host=${DB_HOST} \
    --db_port=${DB_PORT} \
    --db_user=${DB_USER} \
    --db_password=${DB_PASSWORD} \
    --admin_passwd=${ODOO_ADMIN_PASSWD} \
    --data_dir=/var/lib/odoo \
    --addons-path=/usr/lib/python3/dist-packages/odoo/addons,/mnt/extra-addons \
    --proxy-mode \
    --log-level=info \
    --limit-time-cpu=600 \
    --limit-time-real=1200 \
    --db-filter=.* \
    "$@"
