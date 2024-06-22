#!/bin/sh
set -e


# If the CURRENT_IP is empty, fall back to the first IP address
if [ -z "$CURRENT_IP" ]; then
    CURRENT_IP=$(hostname -I | awk '{print $1}')
fi
echo "CURRENT_IP ::  $CURRENT_IP"

ENV_FILE="/var/www/html/.env"
ENV_EXAMPLE_FILE="/var/www/html/.env.example"

#Load the .env file
if [ -f "$ENV_FILE" ]; then
    echo ".env file found..."
else
    echo ".env file not found. Creating from .env.example..."
    # Copy .env.example to .env
    cp "$ENV_EXAMPLE_FILE" "$ENV_FILE"
fi
. "$ENV_FILE"
# Check if APP_KEY is set and not empty
if [ -z "$APP_KEY" ]; then
    echo "APP_KEY is empty. Generating a new key..."
    echo "APP_URL..."
    echo "$APP_URL"
    # Update APP_URL
    sed -i 's|APP_URL=http://localhost|APP_URL=104.197.144.178:8087|' "$ENV_FILE"
    echo "APP_URL..."
    echo "$APP_URL"

    # Update database configuration
    echo "DB_HOST..."
    echo "$DB_HOST"
    sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mariadb/' "$ENV_FILE"
    echo "DB_HOST..."
    echo "$DB_HOST"
    sed -i 's/DB_DATABASE=laravel/DB_DATABASE=jenkinslabtest/' "$ENV_FILE"
    sed -i 's/DB_USERNAME=root/DB_USERNAME=root/' "$ENV_FILE"
    sed -i 's/DB_PASSWORD=/DB_PASSWORD=123465/' "$ENV_FILE"
    echo "Configuration updated. Generating a new key..."
    php artisan key:generate
else
    echo "$APP_KEY"
    echo "APP_KEY is already set."

    echo "APP_URL..."
    echo "$APP_URL"
    # Update APP_URL
    sed -i 's|APP_URL=http://localhost|APP_URL=http://104.197.144.178:8087|' "$ENV_FILE"
    echo "APP_URL..."
    echo "$APP_URL"

    echo "Configuration updated. Generating a new key..."
    php artisan key:generate
fi

# if [ -f /var/www/html/.env ]; then
#     echo ".env file found............................"
#     source /var/www/html/.env
# else
#     echo ".env file not found................................."
# fi

echo "call optimize:clear command to clear all"
php artisan optimize:clear

echo "running migration!"
php artisan migrate