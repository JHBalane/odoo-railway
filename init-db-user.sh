#!/bin/bash
# Script zum Erstellen eines Odoo Datenbank-Users in Railway PostgreSQL

# Dieses Script einmalig ausführen mit Railway CLI:
# railway run bash init-db-user.sh

echo "Creating Odoo database user..."

# Verbinde zu PostgreSQL und erstelle Odoo User
PGPASSWORD=$POSTGRES_PASSWORD psql -h $PGHOST -p $PGPORT -U $POSTGRES_USER -d $POSTGRES_DB <<-EOSQL
    -- Erstelle Odoo User falls nicht existiert
    DO \$\$
    BEGIN
        IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = 'odoo') THEN
            CREATE USER odoo WITH PASSWORD 'odoo_secure_password_2024';
        END IF;
    END
    \$\$;

    -- Gebe dem User die nötigen Rechte
    ALTER USER odoo CREATEDB;
    GRANT ALL PRIVILEGES ON DATABASE railway TO odoo;

    -- Zeige alle User
    SELECT usename, usecreatedb FROM pg_catalog.pg_user;
EOSQL

echo "Odoo user created successfully!"
echo "Username: odoo"
echo "Password: odoo_secure_password_2024"
