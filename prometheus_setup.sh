#!/bin/bash

# Prometheus Installation Script
# Standard paths: /etc/prometheus (config), /var/lib/prometheus (data)
# Version: 3.5.0

set -e

# Set hostname
echo "prometheus" > /etc/hostname
hostname prometheus

# Variables
PROM_VERSION="3.5.0"
DOWNLOAD_URL="https://github.com/prometheus/prometheus/releases/download/v${PROM_VERSION}/prometheus-${PROM_VERSION}.linux-amd64.tar.gz"
TAR_FILE="prometheus-${PROM_VERSION}.linux-amd64.tar.gz"
EXTRACT_DIR="prometheus-${PROM_VERSION}.linux-amd64"
WORK_DIR="/tmp/prom"
CONFIG_DIR="/etc/prometheus"
DATA_DIR="/var/lib/prometheus"
BIN_DIR="/usr/local/bin"
SERVICE_FILE="/etc/systemd/system/prometheus.service"

# Create working directory
mkdir -p "${WORK_DIR}"
cd "${WORK_DIR}"
