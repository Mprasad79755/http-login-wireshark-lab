#!/bin/bash

set -e

LAB_DIR="/var/www/html/testlogin"
LAB_URL="http://127.0.0.1/testlogin/login.html"

echo "=========================================="
echo " HTTP + Wireshark Login Lab"
echo "=========================================="

echo
echo "[1/7] Checking root privileges..."

if [ "$EUID" -ne 0 ]; then
    echo "Please run this script using sudo."
    echo
    echo "Example:"
    echo "sudo bash setup.sh"
    exit 1
fi

echo "Root privileges: OK"

echo
echo "[2/7] Installing Apache and PHP..."

apt-get update

apt-get install -y apache2 php

echo "Apache and PHP: OK"

echo
echo "[3/7] Starting Apache..."

systemctl enable apache2
systemctl restart apache2

if systemctl is-active --quiet apache2; then
    echo "Apache is running."
else
    echo "ERROR: Apache failed to start."
    systemctl status apache2 --no-pager
    exit 1
fi

echo
echo "[4/7] Creating lab directory..."

mkdir -p "$LAB_DIR"

echo "Directory created:"
echo "$LAB_DIR"

echo
echo "[5/7] Copying lab files..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$SCRIPT_DIR/login.html" ]; then
    echo "ERROR: login.html not found."
    exit 1
fi

if [ ! -f "$SCRIPT_DIR/login.php" ]; then
    echo "ERROR: login.php not found."
    exit 1
fi

cp "$SCRIPT_DIR/login.html" "$LAB_DIR/login.html"
cp "$SCRIPT_DIR/login.php" "$LAB_DIR/login.php"

chmod 644 "$LAB_DIR/login.html"
chmod 644 "$LAB_DIR/login.php"

chown -R www-data:www-data "$LAB_DIR"

echo "Files copied successfully."

echo
echo "[6/7] Testing the web server..."

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$LAB_URL")

if [ "$HTTP_STATUS" = "200" ]; then
    echo "Web server test: SUCCESS"
    echo "HTTP Status: $HTTP_STATUS"
else
    echo "ERROR: Web server returned HTTP status $HTTP_STATUS"
    exit 1
fi

echo
echo "[7/7] Opening browser..."

sleep 2

if command -v google-chrome >/dev/null 2>&1; then

    google-chrome "$LAB_URL" >/dev/null 2>&1 &

elif command -v google-chrome-stable >/dev/null 2>&1; then

    google-chrome-stable "$LAB_URL" >/dev/null 2>&1 &

elif command -v chromium >/dev/null 2>&1; then

    chromium "$LAB_URL" >/dev/null 2>&1 &

elif command -v chromium-browser >/dev/null 2>&1; then

    chromium-browser "$LAB_URL" >/dev/null 2>&1 &

elif command -v firefox >/dev/null 2>&1; then

    firefox "$LAB_URL" >/dev/null 2>&1 &

else

    echo "No supported browser found."
    echo "Open manually:"
    echo "$LAB_URL"

fi

echo
echo "=========================================="
echo " LAB READY"
echo "=========================================="
echo
echo "Login URL:"
echo "$LAB_URL"
echo
echo "Use the lab credentials:"
echo "Username: admin"
echo "Password: test123"
echo
echo "Wireshark:"
echo "1. Select the 'lo' interface."
echo "2. Start capture."
echo "3. Apply:"
echo '   http.request.method == "POST"'
echo "4. Submit the login form."
echo "5. Right-click the POST packet."
echo "6. Follow -> TCP Stream."
echo
echo "=========================================="