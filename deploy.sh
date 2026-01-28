#!/bin/bash
# ===========================================
# Cloud-1 Deployment Script
# ===========================================
# Automated deployment of WordPress on a remote server
#
# Prerequisites:
# - Ubuntu 20.04 LTS server with SSH and Python installed
# - Server IP added to ansible/inventory/hosts.yml
#
# Usage:
#   ./deploy.sh
# ===========================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="${SCRIPT_DIR}/ansible"

echo "========================================"
echo "       Cloud-1 Deployment Script        "
echo "========================================"

# Check Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo "[ERROR] Ansible not found. Install with: pip install ansible"
    exit 1
fi

# Load environment variables if .env exists
if [ -f "${SCRIPT_DIR}/.env" ]; then
    echo "[INFO] Loading environment from .env"
    export $(grep -v '^#' "${SCRIPT_DIR}/.env" | xargs)
fi

# Run the main playbook
echo "[INFO] Running Ansible playbook..."
cd "${ANSIBLE_DIR}"

EXTRA_VARS=""
if [ -n "$DOMAIN_NAME" ]; then
    EXTRA_VARS="$EXTRA_VARS domain_name=$DOMAIN_NAME"
fi
if [ -n "$LETSENCRYPT_EMAIL" ]; then
    EXTRA_VARS="$EXTRA_VARS letsencrypt_email=$LETSENCRYPT_EMAIL"
fi

if [ -n "$EXTRA_VARS" ]; then
    ansible-playbook playbooks/main.yml --extra-vars "$EXTRA_VARS"
else
    ansible-playbook playbooks/main.yml
fi

echo ""
echo "========================================"
echo "       Deployment Complete!             "
echo "========================================"
