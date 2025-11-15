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

# Erstelle Odoo Config dynamisch mit Umgebungsvariablen
cat > /tmp/odoo.conf <<EOF
[options]
http_port = ${HTTP_PORT}
http_interface = 0.0.0.0
db_host = ${DB_HOST}
db_port = ${DB_PORT}
db_user = ${DB_USER}
db_password = ${DB_PASSWORD}
db_name = False
db_maxconn = 64
dbfilter = .*
admin_passwd = ${ODOO_ADMIN_PASSWD}
log_level = info
log_handler = :INFO
data_dir = /var/lib/odoo
addons_path = /usr/lib/python3/dist-packages/odoo/addons,/mnt/extra-addons
proxy_mode = True
limit_time_cpu = 600
limit_time_real = 1200
limit_memory_hard = 2684354560
limit_memory_soft = 2147483648
csv_internal_sep = ,
list_db = True
EOF

# Start Odoo mit der generierten Config
exec odoo -c /tmp/odoo.conf "$@"
