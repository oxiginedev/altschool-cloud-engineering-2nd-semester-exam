#!/bin/bash

INSTALL_DIR="/var/www/html/laravel"

# Update package index and upgrade packages
sudo apt update && sudo apt upgrade -y

# Update PHP repository
sudo add-apt repository -y ppa:ondrej/php
sudo apt update

# Install Apache2, MySQL and other required PHP packages
sudo apt install -y apache2 git curl mysql-server libapache2-mod-php8.2 php8.2 php8.2-{curl,dom,xml,mysql,pdo}

sudo systemctl enable apache2
sudo systemctl restart apache2

# Setup composer
curl -sS https://getcomposer.org/installer | php --install-dir=/usr/local/bin --filename=composer

# Clone Laravel github repository
sudo git clone https://github.com/laravel/laravel.git $INSTALL_DIR

# Configure ownership and file permissions
sudo chown www-data:www-data $INSTALL_DIR
sudo chmod -R 775 $INSTALL_DIR/bootstrap/cache $INSTALL_DIR/storage

# Install app dependencies with composer
cd $INSTALL_DIR

sudo composer install --prefer-dist --no-dev

sudo cp .env.example .env

# Generate application key
sudo php artisan key:generate

# Run pending database migrations
sudo php artisan migrate

# Configure virtual host in /etc/apache2/sites-available
sudo tee /etc/apache2/sites-available/laravel.conf >/dev/null <<EOF
<VirtualHost *:80>
    ServerName 192.168.58.6
    ServerAlias *
    DocumentRoot $INSTALL_DIR/public

    <Directory $INSTALL_DIR>
        AllowOveride All
    </Directory>
</VirualHost>
EOF

# Final Apache2 cleanup
sudo a2dissite 000-default.conf
sudo a2ensite laravel.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "LAMP stack installation completed!"