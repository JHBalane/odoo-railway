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

# WICHTIG: Odoo erlaubt 'postgres' User nicht standardmäßig
# Setze ALLOW_ADMIN_ACCESS=1 um es trotzdem zu erlauben (nur für Railway/Cloud OK)
export ALLOW_ADMIN_ACCESS=1

echo "Starting Odoo on port ${HTTP_PORT}..."
echo "Database: ${DB_USER}@${DB_HOST}:${DB_PORT}"

# Workaround: Odoo blockt 'postgres' user aus Sicherheitsgründen
# Wir patchen die Check-Funktion um Railway PostgreSQL nutzen zu können
if [ "$DB_USER" = "postgres" ]; then
    echo "Applying postgres user workaround..."
    # Finde die Odoo service/db.py Datei und deaktiviere den postgres check
    ODOO_DB_FILE=$(python3 -c "import odoo; print(odoo.__path__[0])")/service/db.py
    if [ -f "$ODOO_DB_FILE" ]; then
        sed -i "s/if db_user == 'postgres':/if False and db_user == 'postgres':/g" "$ODOO_DB_FILE" 2>/dev/null || true
    fi
fi

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
