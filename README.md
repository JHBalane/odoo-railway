# Odoo Community Edition auf Railway

Dieses Projekt ermöglicht es dir, **Odoo Community Edition** (Open Source ERP/CRM) auf Railway zu hosten.

## 🚀 Was ist Odoo?

Odoo ist eine All-in-One Business Management Software mit folgenden Modulen:
- **CRM** - Kundenbeziehungsmanagement
- **Sales** - Verkaufsmanagement
- **Inventory** - Lagerverwaltung
- **Accounting** - Buchhaltung
- **HR** - Personalverwaltung
- **Project Management** - Projektmanagement
- Und viele mehr!

## 📋 Voraussetzungen

- [Railway Account](https://railway.app/)
- [Railway CLI](https://docs.railway.app/develop/cli) (optional, aber empfohlen)
- Git
- Docker & Docker Compose (für lokales Testing)

## 🏗️ Projekt-Struktur

```
odoo-railway/
├── Dockerfile              # Docker Image für Odoo
├── docker-compose.yml      # Für lokales Testing
├── odoo.conf              # Odoo Konfiguration
├── railway.toml           # Railway Deployment Config
├── .env.example           # Beispiel Umgebungsvariablen
├── .gitignore
└── README.md
```

## 🧪 Lokales Testing (Optional)

Bevor du auf Railway deployst, kannst du das Setup lokal testen:

### 1. Docker Compose starten

```bash
docker-compose up -d
```

### 2. Odoo öffnen

Öffne deinen Browser und gehe zu:
```
http://localhost:8069
```

**Standard Login:**
- Beim ersten Start wirst du aufgefordert, eine Datenbank zu erstellen
- Master Password: `admin123` (siehe docker-compose.yml)

### 3. Stoppen

```bash
docker-compose down
```

Um auch die Datenbank zu löschen:
```bash
docker-compose down -v
```

## 🚂 Deployment auf Railway

### Variante 1: Über Railway Dashboard (Einfachste Methode)

#### Schritt 1: GitHub Repository erstellen

```bash
# Im odoo-railway Verzeichnis
git add .
git commit -m "Initial Odoo Railway setup"

# Erstelle ein neues GitHub Repository und pushe
git remote add origin https://github.com/dein-username/odoo-railway.git
git branch -M main
git push -u origin main
```

#### Schritt 2: Railway Projekt erstellen

1. Gehe zu [railway.app](https://railway.app/)
2. Klicke auf **"New Project"**
3. Wähle **"Deploy from GitHub repo"**
4. Wähle dein `odoo-railway` Repository

#### Schritt 3: PostgreSQL hinzufügen

1. Im Railway Dashboard, klicke auf **"+ New"**
2. Wähle **"Database" → "Add PostgreSQL"**
3. Railway erstellt automatisch die Datenbank und verknüpft sie

#### Schritt 4: Umgebungsvariablen setzen

Railway setzt automatisch PostgreSQL Variablen (`PGHOST`, `PGPORT`, etc.).
Du musst nur **eine** wichtige Variable manuell hinzufügen:

1. Klicke auf deinen Odoo Service
2. Gehe zu **"Variables"**
3. Füge hinzu:
   ```
   ADMIN_PASSWD=dein-super-sicheres-passwort
   ```

**WICHTIG:** Dieses Passwort wird benötigt, um Odoo-Datenbanken zu erstellen/verwalten!

#### Schritt 5: Volume für Persistent Storage erstellen

1. Klicke auf deinen Odoo Service
2. Gehe zu **"Settings" → "Volumes"**
3. Klicke auf **"Add Volume"**
4. Mount Path: `/var/lib/odoo`

#### Schritt 6: Deploy starten

Railway startet automatisch das Deployment. Warte, bis es abgeschlossen ist (~3-5 Minuten).

#### Schritt 7: URL öffnen

1. Klicke auf deinen Odoo Service
2. Unter **"Settings" → "Networking"** findest du die generierte URL
3. Oder klicke auf **"Open App"**

### Variante 2: Über Railway CLI

```bash
# Railway CLI installieren (falls noch nicht geschehen)
npm install -g @railway/cli

# Login
railway login

# Neues Projekt erstellen
railway init

# PostgreSQL hinzufügen
railway add --database postgresql

# Umgebungsvariablen setzen
railway variables set ADMIN_PASSWD=dein-super-sicheres-passwort

# Deployen
railway up
```

## 🎯 Erste Schritte nach dem Deployment

### 1. Odoo öffnen

Öffne die Railway URL in deinem Browser.

### 2. Datenbank erstellen

Beim ersten Besuch siehst du den "Database Manager":

1. **Master Password:** Das `ADMIN_PASSWD`, das du in Railway gesetzt hast
2. **Database Name:** z.B. `production`
3. **Email:** Deine Admin-Email
4. **Password:** Dein Odoo Admin-Passwort (für den Login)
5. **Language:** Deutsch oder Englisch
6. **Country:** Deutschland
7. Wähle **Demo Data** ab (für Production)

Klicke auf **"Create Database"**

### 3. Login

Nach der Erstellung wirst du automatisch eingeloggt.

### 4. Apps installieren

Gehe zu **"Apps"** und installiere die Module, die du brauchst:
- **CRM** - für Kundenmanagement
- **Sales** - für Verkauf
- **Accounting** - für Buchhaltung
- usw.

## 🔧 Konfiguration

### Umgebungsvariablen

Alle wichtigen Variablen in Railway:

| Variable | Beschreibung | Automatisch gesetzt? |
|----------|--------------|---------------------|
| `PORT` | HTTP Port | ✅ Ja (Railway) |
| `PGHOST` | PostgreSQL Host | ✅ Ja (Railway DB) |
| `PGPORT` | PostgreSQL Port | ✅ Ja (Railway DB) |
| `PGUSER` | DB Username | ✅ Ja (Railway DB) |
| `PGPASSWORD` | DB Passwort | ✅ Ja (Railway DB) |
| `ADMIN_PASSWD` | Odoo Master Password | ❌ **Manuell setzen!** |

### Odoo Version ändern

Um eine andere Odoo Version zu nutzen, ändere in `Dockerfile`:

```dockerfile
FROM odoo:17.0  # Ändere zu z.B. odoo:16.0, odoo:15.0
```

Verfügbare Versionen: [Odoo Docker Hub](https://hub.docker.com/_/odoo)

## 📦 Custom Addons hinzufügen

### 1. Erstelle einen `addons` Ordner

```bash
mkdir addons
```

### 2. Füge deine Custom Addons hinzu

```bash
# Beispiel: Clone ein Custom Addon
cd addons
git clone https://github.com/example/custom-addon.git
```

### 3. Update .gitignore

Entferne `addons/` aus `.gitignore` falls du die Addons mit einchecken willst.

### 4. Deploy erneut

```bash
git add .
git commit -m "Add custom addons"
git push
```

Railway deployt automatisch neu.

## 🛡️ Sicherheit

### Wichtige Sicherheitshinweise:

1. **ADMIN_PASSWD sicher wählen**
   - Mindestens 20 Zeichen
   - Zufällig generiert
   - Niemals im Code speichern!

2. **Datenbank Zugriff beschränken**
   - In `odoo.conf`: Setze `list_db = False` in Production
   - Entferne Database Manager aus public access

3. **SSL/HTTPS**
   - Railway stellt automatisch HTTPS bereit ✅

4. **Backups**
   - Railway bietet keine automatischen Backups
   - Nutze Odoo's Backup Funktion regelmäßig
   - Oder: Nutze Railway's PostgreSQL Backup Add-on

## 📊 Performance Optimierung

Für Production Workloads, ändere in `odoo.conf`:

```conf
# Aktiviere Workers (für bessere Performance)
workers = 2
max_cron_threads = 1

# Deaktiviere Demo Data
without_demo = True

# Logging auf Warning setzen
log_level = warn
```

Und in Railway: Upgrade auf einen größeren Plan für mehr RAM/CPU.

## 🔍 Troubleshooting

### Problem: Deployment schlägt fehl

**Lösung:**
- Checke die Railway Logs
- Stelle sicher, dass PostgreSQL läuft
- Überprüfe Umgebungsvariablen

### Problem: Kann keine Datenbank erstellen

**Lösung:**
- Überprüfe ob `ADMIN_PASSWD` gesetzt ist
- Checke PostgreSQL Connection Variablen

### Problem: Odoo ist langsam

**Lösung:**
- Aktiviere Workers in `odoo.conf`
- Upgrade Railway Plan
- Deaktiviere unnötige Apps

### Problem: "Internal Server Error"

**Lösung:**
- Checke Railway Logs: `railway logs`
- Stelle sicher, dass PostgreSQL erreichbar ist
- Überprüfe die `odoo.conf` Syntax

## 📝 Weitere Ressourcen

- [Odoo Dokumentation](https://www.odoo.com/documentation/17.0/)
- [Railway Dokumentation](https://docs.railway.app/)
- [Odoo Community Forum](https://www.odoo.com/forum)
- [Odoo GitHub](https://github.com/odoo/odoo)

## 🤝 Contributing

Verbesserungen sind willkommen! Erstelle gerne einen Pull Request.

## 📄 Lizenz

Dieses Setup ist MIT lizenziert.
Odoo Community Edition ist LGPL v3 lizenziert.

## ⚡ Quick Start Zusammenfassung

```bash
# 1. Repository clonen
git clone https://github.com/dein-username/odoo-railway.git
cd odoo-railway

# 2. Auf Railway deployen
railway login
railway init
railway add --database postgresql
railway variables set ADMIN_PASSWD=dein-passwort
railway up

# 3. Fertig! Öffne die URL und erstelle deine erste Datenbank
```

---

**Viel Erfolg mit deinem Odoo CRM auf Railway! 🎉**
