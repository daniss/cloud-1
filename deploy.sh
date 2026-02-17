#!/bin/bash
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
    ANSIBLE_CONFIG="${ANSIBLE_DIR}/ansible.cfg" ansible-playbook -i inventory/hosts.yml playbooks/main.yml --extra-vars "$EXTRA_VARS"
else
    ANSIBLE_CONFIG="${ANSIBLE_DIR}/ansible.cfg" ansible-playbook -i inventory/hosts.yml playbooks/main.yml
fi

echo ""
echo "========================================"
echo "       Deployment Complete!             "
echo "========================================"
