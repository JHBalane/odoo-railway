# PostgreSQL Odoo User erstellen

Odoo erlaubt aus Sicherheitsgründen nicht den `postgres` Superuser zu verwenden.
Wir müssen einen separaten `odoo` User erstellen.

## Einmalige Einrichtung über Railway CLI:

### Schritt 1: In PostgreSQL Service einloggen

```bash
cd ~/odoo-railway
railway link
railway service  # Wähle "PostgreSQL"
```

### Schritt 2: User erstellen

```bash
railway run psql $DATABASE_URL -c "CREATE USER odoo WITH PASSWORD 'OdooSecure2024!'; ALTER USER odoo CREATEDB;"
```

### Schritt 3: Rechte vergeben

```bash
railway run psql $DATABASE_URL -c "GRANT ALL PRIVILEGES ON DATABASE railway TO odoo;"
```

### Schritt 4: Odoo Service Variablen anpassen

Gehe zu Railway → Odoo Service → Variables und ändere:

**Vorher:**
```
PGUSER=${{PostgreSQL.POSTGRES_USER}}
PGPASSWORD=${{PostgreSQL.POSTGRES_PASSWORD}}
```

**Nachher:**
```
PGUSER=odoo
PGPASSWORD=OdooSecure2024!
```

## Alternativer einfacher Weg:

Ändere in Railway die Odoo Umgebungsvariablen direkt auf feste Werte:

```
PGHOST=${{PostgreSQL.RAILWAY_PRIVATE_DOMAIN}}
PGPORT=5432
PGUSER=odoo
PGPASSWORD=OdooSecure2024!
```

Dann führe diesen Befehl aus:

```bash
cd ~/odoo-railway
railway link
railway service  # Wähle PostgreSQL
railway run bash -c "PGPASSWORD=\$POSTGRES_PASSWORD psql -h \$RAILWAY_PRIVATE_DOMAIN -U postgres -d railway -c \"CREATE USER odoo WITH PASSWORD 'OdooSecure2024!' CREATEDB; GRANT ALL PRIVILEGES ON DATABASE railway TO odoo;\""
```
