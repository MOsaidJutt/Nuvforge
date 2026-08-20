#!/usr/bin/env bash
# Nuvforge deploy script. Run ON THE VPS as a sudo-capable user.
# First run installs everything; later runs just pull the latest code.
set -euo pipefail

REPO="https://github.com/MOsaidJutt/Nuvforge.git"
DIR="/var/www/nuvforge"

if ! command -v nginx >/dev/null 2>&1; then
    echo "==> Installing nginx"
    sudo apt update && sudo apt install -y nginx git
fi

if [ -d "$DIR/.git" ]; then
    echo "==> Updating existing checkout"
    sudo git -C "$DIR" pull --ff-only
else
    echo "==> Cloning repo"
    sudo mkdir -p /var/www
    sudo git clone "$REPO" "$DIR"
fi

echo "==> Installing nginx config"
sudo cp "$DIR/deploy/nginx-nuvforge.conf" /etc/nginx/sites-available/nuvforge.conf
sudo ln -sf /etc/nginx/sites-available/nuvforge.conf /etc/nginx/sites-enabled/nuvforge.conf

echo "==> Testing + reloading nginx"
sudo nginx -t
sudo systemctl reload nginx

echo "==> Done. nuvforge.com -> $DIR/site | tax.nuvforge.com -> $DIR/tax"
