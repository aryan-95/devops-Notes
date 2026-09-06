#!/bin/bash

# ============================================================
# Grafana Enterprise Installation Script
# Ubuntu / Debian
# ============================================================

set -e

GRAFANA_REPO="https://apt.grafana.com"
SERVICE="grafana-server"

echo "=========================================="
echo " Installing Grafana Enterprise"
echo "=========================================="

# ------------------------------------------------------------
# 1. Update system
# ------------------------------------------------------------

echo "[1/7] Updating system..."

sudo apt-get update -y

# ------------------------------------------------------------
# 2. Install dependencies
# ------------------------------------------------------------

echo "[2/7] Installing dependencies..."

sudo apt-get install -y \
    apt-transport-https \
    software-properties-common \
    wget \
    gnupg \
    ca-certificates \
    adduser \
    libfontconfig1 \
    musl

# ------------------------------------------------------------
# 3. Add Grafana GPG key
# ------------------------------------------------------------

echo "[3/7] Adding Grafana repository key..."

sudo mkdir -p /etc/apt/keyrings

wget -q -O - https://apt.grafana.com/gpg.key | \
    gpg --dearmor | \
    sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null

sudo chmod 644 /etc/apt/keyrings/grafana.gpg

# ------------------------------------------------------------
# 4. Add Grafana repository
# ------------------------------------------------------------

echo "[4/7] Adding Grafana repository..."

echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] ${GRAFANA_REPO} stable main" | \
    sudo tee /etc/apt/sources.list.d/grafana.list > /dev/null

sudo apt-get update -y

# ------------------------------------------------------------
# 5. Install Grafana Enterprise
# ------------------------------------------------------------

echo "[5/7] Installing Grafana Enterprise..."

sudo apt-get install -y grafana-enterprise

# ------------------------------------------------------------
# 6. Enable and start Grafana
# ------------------------------------------------------------

echo "[6/7] Starting Grafana..."

sudo systemctl daemon-reload

sudo systemctl enable grafana-server

sudo systemctl start grafana-server

# ------------------------------------------------------------
# 7. Verify installation
# ------------------------------------------------------------

echo "[7/7] Checking Grafana service..."

if sudo systemctl is-active --quiet grafana-server; then
    echo ""
    echo "=========================================="
    echo " Grafana installed successfully!"
    echo "=========================================="
    echo ""
    echo "Config : /etc/grafana/grafana.ini"
    echo "Data   : /var/lib/grafana/"
    echo "Logs   : /var/log/grafana/"
    echo "Service: grafana-server"
    echo ""
    echo "Check status:"
    echo "sudo systemctl status grafana-server"
    echo ""
    echo "Grafana runs on:"
    echo "http://YOUR_SERVER_IP:3000"
    echo ""
else
    echo ""
    echo "ERROR: Grafana service failed to start."
    echo ""
    echo "Check logs with:"
    echo "sudo journalctl -u grafana-server -xe"
    exit 1
fi