FROM odoo:18.0

USER root

# Install system utilities and nodejs for rtlcss (Arabic PDF alignment)
RUN apt-get update && apt-get install -y npm git && \
    npm install -g rtlcss && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install your custom module dependencies
COPY requirements.txt /opt/requirements.txt
RUN pip3 install --no-cache-dir --break-system-packages --ignore-installed -r /opt/requirements.txt

# Sync your configuration and modules code
COPY odoo.conf /etc/odoo/odoo.conf
COPY ./custom_addons /var/lib/odoo/custom_addons

RUN chown -R odoo:odoo /var/lib/odoo/custom_addons

USER odoo

# Dynamically inject Render Environment Variables into Odoo on startup
CMD ["sh", "-c", "odoo --config=/etc/odoo/odoo.conf --db_host=$DB_HOST --db_user=$DB_USER --db_password=$DB_PASSWORD --db_port=$DB_PORT --db_name=$DB_NAME"]