# Odoo Community Edition für Railway
FROM odoo:17.0

# Als root für Installation
USER root

# Arbeitsverzeichnis
WORKDIR /opt/odoo

# Installiere zusätzliche Python Dependencies (falls benötigt)
# COPY requirements.txt .
# RUN pip3 install -r requirements.txt

# Erstelle notwendige Verzeichnisse
RUN mkdir -p /var/lib/odoo /mnt/extra-addons

# Kopiere Startup Script
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

# Setze Berechtigungen
RUN chmod +x /usr/local/bin/entrypoint.sh && \
    chown -R odoo:odoo /var/lib/odoo /mnt/extra-addons

# Wechsel zu odoo User
USER odoo

# Railway verwendet die PORT Umgebungsvariable
# Odoo läuft standardmäßig auf Port 8069, aber Railway weist dynamisch zu
EXPOSE ${PORT:-8069}

# Entrypoint - Railway startet automatisch
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
