#!/usr/bin/env bash

# Install Nginx if it is not already installed
if ! [ -x "$(command -v nginx)" ]; then
  apt-get update
  apt-get install nginx -y
fi

# Create the /data/ folder if it doesn't already exist
if ! [ -d "/data" ]; then
  mkdir /data
fi

# Create the /data/web_static/ folder if it doesn't already exist
if ! [ -d "/data/web_static" ]; then
  mkdir /data/web_static
fi

# Create the /data/web_static/releases/ folder if it doesn't already exist
if ! [ -d "/data/web_static/releases" ]; then
  mkdir /data/web_static/releases
fi

# Create the /data/web_static/shared/ folder if it doesn't already exist
if ! [ -d "/data/web_static/shared" ]; then
  mkdir /data/web_static/shared
fi

# Create the /data/web_static/releases/test/ folder if it doesn't already exist
if ! [ -d "/data/web_static/releases/test" ]; then
  mkdir /data/web_static/releases/test
fi

# Create a fake HTML file /data/web_static/releases/test/index.html with simple content
echo "<html>
  <head>
  </head>
  <body>
    <h1> Welcome to www.g-site.tech </h1>
  </body>
</html>" > /data/web_static/releases/test/index.html

# Create a symbolic link /data/web_static/current linked to the /data/web_static/releases/test/ folder
# If the symbolic link already exists, delete it and recreate it
if [ -L "/data/web_static/current" ]; then
  rm /data/web_static/current
fi
ln -s /data/web_static/releases/test /data/web_static/current

# Give ownership of the /data/ folder to the ubuntu user and group (recursively)
chown -R ubuntu:ubuntu /data

# Update the Nginx configuration to serve the content of /data/web_static/current/ to hbnb_static
# Use alias inside the Nginx configuration
sed -i "s|root /var/www/html;|alias /data/web_static/current;|g" /etc/nginx/sites-available/default

# Restart Nginx
systemctl restart nginx
