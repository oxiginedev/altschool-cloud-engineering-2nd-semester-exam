#!/bin/bash

# Define database variables
$DB_DATABASE="laravel"
$DB_PASSWORD="password"

# Update package lists
sudo apt update
sudo apt upgrade -y

sudo apt install ca-certificates apt-transport-https software-properties-common lsb-release -y

sudo add-apt-repository ppa:ondrej/php -y

sudo apt update
sudo apt upgrade -y

sudo apt-get install -y apache2 libapache2-mod-php8.3 git mysql-server curl php8.3 php8.3-{cli,curl,dom,mbstring,pdo,mysql,zip,unzip,xml,openssl}

sudo systemctl start apache2
sudo systemctl start mysql

sudo systemctl enable apache2
sudo systemctl enable mysql

# Secure MYSQL installation
sudo mysql_secure_installation << EOF
y
$DB_PASSWORD
$DB_PASSWORD
y
y
y
EOF

# Download Composer installer script
curl -sS https://getcomposer.org/installer | php --install-dir=/usr/local/bin --filename=composer

git clone https://github.com/laravel/laravel.git /var/www/html/laravel

sudo chown -R www-data:www-data /var/www/html/laravel/bootstrap/cache
sudo chown -R www-data:www-data /var/www/html/laravel/storage
sudo chmod -R 775 /var/www/html/laravel/storage

# Configure Apache for Laravel
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/site-available/laravel.conf
sudo sed -i 's/\/var\/www\/html/\/www\/html\/laravel\/public/g' /etc/apache2/sites-available/laravel.conf
sudo a2ensite laravel.conf
sudo a2enmod rewrite
sudo systemctl restart apache2

# Install laravel dependencies
sudo cd /var/www/html/laravel
sudo cp .env.example .env
composer install --optimize-autoloader --prefer-dist
php artisan key:generate

echo "LAMP stack and laravel application deployment completed successfully!"
