# Cloud-1: Automated WordPress Deployment

Automated deployment of WordPress on a remote server using Ansible and Docker.

## Prerequisites

- Ubuntu 20.04 LTS server with SSH daemon and Python installed
- Ansible installed locally (`pip install ansible`)
- SSH key access to the server

## Quick Start

1. Add your server IP to `ansible/inventory/hosts.yml`:
   ```yaml
   webservers:
     hosts:
       web1:
         ansible_host: YOUR_SERVER_IP
   ```

2. Configure credentials (optional):
   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

3. Deploy:
   ```bash
   chmod +x deploy.sh
   ./deploy.sh
   ```

## What Gets Deployed

| Container | Purpose |
|-----------|---------|
| nginx | Reverse proxy (ports 80, 443) |
| wordpress | WordPress with PHP-FPM |
| mysql | Database (internal only) |
| phpmyadmin | Database management |

## Features

- ✅ Auto-restart on server reboot
- ✅ Data persistence (Docker volumes)
- ✅ Database not exposed to internet
- ✅ TLS support (Let's Encrypt)
- ✅ URL-based routing
- ✅ Only ports 22, 80, and 443 exposed via UFW
- ✅ Parallel deployment support

## Access

- WordPress: `http://<server-ip>` or `https://<domain>`
- PHPMyAdmin: `http://<server-ip>/phpmyadmin`

## Project Structure

```
cloud-1/
├── ansible/
│   ├── ansible.cfg
│   ├── inventory/hosts.yml
│   ├── inventory/group_vars/all.yml
│   ├── playbooks/main.yml
│   └── roles/
│       ├── common/
│       ├── docker/
│       ├── security/
│       ├── wordpress/
│       └── ssl/
├── .env.example
├── deploy.sh
└── README.md
```
