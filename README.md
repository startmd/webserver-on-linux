# 🚀 Linux Dev Environment Setup Script

A comprehensive, interactive bash script for setting up a complete local development environment on **Linux Mint** and **Ubuntu**. This script automates the installation and configuration of essential web development tools, including Apache2, MySQL, PHP, Node.js, IDE editors, database management tools, and a self-hosted Git service.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![OS](https://img.shields.io/badge/OS-Linux%20Mint%20%7C%20Ubuntu-green.svg)
![Bash](https://img.shields.io/badge/Bash-4.0%2B-orange.svg)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Installation Components](#installation-components)
  - [Apache2 Web Server](#apache2-web-server)
  - [MySQL Database Server](#mysql-database-server)
  - [PHP Runtime](#php-runtime)
  - [Node.js Runtime](#nodejs-runtime)
  - [Code Editors](#code-editors)
  - [AdminerEvo](#adminerevo)
  - [Gitea Self-Hosted Git](#gitea-self-hosted-git)
  - [Virtual Host Maker](#virtual-host-maker)
- [Configuration Details](#configuration-details)
- [Post-Installation Steps](#post-installation-steps)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

Setting up a local development environment on a fresh Linux installation can be time-consuming and error-prone. This script streamlines the entire process by providing an interactive, step-by-step installation wizard that guides you through each component.

The script is designed with flexibility in mind — you can choose which components to install, configure custom PHP versions, create MySQL development users, and optionally set up a complete self-hosted Git solution with Gitea. Every step requires explicit user confirmation, ensuring you maintain full control over your system configuration.

### Why This Script?

- **Time-Saving**: Automates hours of manual installation and configuration work into a few minutes of interactive prompts
- **Best Practices**: Implements recommended security configurations, permission structures, and service setups
- **Flexibility**: Choose exactly which components you need without installing unnecessary packages
- **Reproducibility**: Create consistent development environments across multiple machines or team members
- **Learning Resource**: Well-commented code helps you understand each step of the setup process

---

## Features

### Core Development Stack

| Component | Description |
|-----------|-------------|
| **Apache2** | Industry-standard web server with virtual host support |
| **MySQL Server** | Relational database management system for local development |
| **PHP** | Server-side scripting language with popular extensions (configurable version) |
| **Node.js 20.x LTS** | JavaScript runtime for modern web development |

### Development Tools

| Tool | Purpose |
|------|---------|
| **Pulsar Editor** | Modern, hackable text editor (community fork of Atom) |
| **Geany** | Lightweight, fast IDE for multiple programming languages |
| **AdminerEvo** | Database management tool (phpMyAdmin alternative) |
| **Gitea** | Self-hosted Git service with web interface |
| **Virtual Host Maker** | CLI tool for creating Apache virtual hosts |

### Key Script Capabilities

- ✅ Interactive configuration with yes/no prompts for each step
- ✅ Automatic repository management (PPA for PHP, NodeSource for Node.js)
- ✅ Configurable PHP version selection (8.1, 8.2, 8.3)
- ✅ MySQL development user creation with custom credentials
- ✅ Proper permission setup for `/var/www/html` directory
- ✅ Apache reverse proxy configuration for Gitea
- ✅ Systemd service setup for Gitea
- ✅ Automatic hosts file modification for local domains

---

## Prerequisites

### System Requirements

Before running this script, ensure your system meets the following requirements:

| Requirement | Details |
|-------------|---------|
| **Operating System** | Linux Mint 20+ or Ubuntu 20.04 LTS (or later) |
| **Architecture** | x86_64 (AMD64) |
| **RAM** | Minimum 2GB (4GB recommended for Gitea) |
| **Disk Space** | At least 5GB free for all components |
| **Internet Connection** | Required for downloading packages and repositories |

### User Permissions

The script must be run with root privileges (`sudo`). It automatically detects the actual non-root user running the command to configure proper permissions for web directories and user groups.

---

## Quick Start

### Download and Execute

Follow these steps to set up your development environment:

```bash
# 1. Download the script
wget https://raw.githubusercontent.com/YOUR_USERNAME/linux-dev-setup/main/setup_dev_env.sh

# 2. Make the script executable
chmod +x setup_dev_env.sh

# 3. Run the script with sudo privileges
sudo ./setup_dev_env.sh
```

### Post-Installation

After the script completes, **log out and log back in** (or reboot) to ensure group permission changes take effect. This is particularly important if the script added your user to the `www-data` group for web directory access.

---

## Installation Components

### Apache2 Web Server

Apache2 is installed as the primary web server, configured to serve files from the default `/var/www/html` directory. The installation includes:

- Core Apache2 modules for serving static and dynamic content
- Integration with PHP via `libapache2-mod-php`
- Virtual host support for multiple local development sites
- Reverse proxy modules for Gitea integration

#### Default Configuration

| Setting | Value |
|---------|-------|
| Document Root | `/var/www/html` |
| Default Port | 80 |
| Configuration Directory | `/etc/apache2/` |
| Sites Directory | `/etc/apache2/sites-available/` |

### MySQL Database Server

MySQL Server provides the database backend for your local development projects. The script offers to create a dedicated development user with full privileges, which is recommended for separating development work from the root account.

#### MySQL User Setup

When prompted, you can create a MySQL development user with:

- Custom username of your choice
- Secure password input (hidden during typing)
- Full privileges on all databases (`GRANT ALL PRIVILEGES`)
- `WITH GRANT OPTION` for administering other users

#### Connecting to MySQL

```bash
# Connect as the development user
mysql -u your_dev_user -p

# Or as root (no password initially)
sudo mysql -u root
```

### PHP Runtime

PHP is installed with a configurable version selector. The script uses the Ondrej PPA, which provides the latest PHP versions even on older Ubuntu/Debian releases.

#### Supported PHP Versions

| Version | Status | Recommended For |
|---------|--------|-----------------|
| PHP 8.1 | Security fixes only | Legacy projects |
| PHP 8.2 | Active support | Most projects |
| PHP 8.3 | Latest stable | New projects |

#### Included PHP Extensions

The script installs a comprehensive set of PHP extensions commonly required by modern web applications and frameworks:

| Extension | Purpose |
|-----------|---------|
| `cli` | Command-line interface for PHP |
| `common` | Common documentation and examples |
| `mysql` | MySQL database driver (mysqli, PDO) |
| `zip` | ZIP archive handling |
| `gd` | Image processing library |
| `mbstring` | Multibyte string support (UTF-8) |
| `curl` | HTTP client library |
| `xml` | XML parsing and manipulation |
| `bcmath` | Arbitrary precision mathematics |
| `intl` | Internationalization support |

### Node.js Runtime

Node.js 20.x LTS is installed via the official NodeSource repository, providing a stable, long-term support version suitable for production and development.

#### What's Included

- Node.js runtime (v20.x LTS)
- npm (Node Package Manager)
- Access to the entire npm ecosystem

#### Verifying Installation

```bash
# Check Node.js version
node --version
# Expected output: v20.x.x

# Check npm version
npm --version
# Expected output: 10.x.x
```

### Code Editors

Two code editors are installed to cater to different development preferences:

#### Pulsar Editor

Pulsar is a community-driven fork of Atom, maintained after Atom's discontinuation. It provides:

- Modern, hackable text editor with a vibrant ecosystem
- Built-in package manager for extensions
- Git integration and GitHub support
- Cross-platform consistency
- Highly customizable UI and functionality

**Official Website**: [pulsar-edit.dev](https://pulsar-edit.dev/)

#### Geany

Geany is a lightweight, fast IDE that uses the Scintilla editing component. It's ideal for:

- Quick edits and small projects
- Systems with limited resources
- Multi-language development
- Fast startup times

**Features**:
- Syntax highlighting for 50+ languages
- Code folding and navigation
- Built-in terminal
- Plugin support

**Official Website**: [geany.org](https://www.geany.org/)

### AdminerEvo

AdminerEvo is a community-maintained fork of Adminer, a lightweight database management tool written in PHP. It serves as an excellent alternative to phpMyAdmin with several advantages:

#### Advantages Over phpMyAdmin

| Feature | AdminerEvo | phpMyAdmin |
|---------|------------|------------|
| Single file deployment | ✅ | ❌ |
| Installation size | ~500KB | ~30MB |
| Memory usage | Low | High |
| Security surface | Minimal | Larger |
| MySQL, PostgreSQL, SQLite | ✅ All | MySQL only |

#### Accessing AdminerEvo

After installation, access AdminerEvo at:

```
http://localhost/adminer
```

Log in with your MySQL credentials (root or the development user you created).

### Gitea Self-Hosted Git

Gitea is a lightweight, self-hosted Git service that provides a web interface for managing Git repositories. It's similar to GitHub but runs entirely on your local machine, giving you complete control over your code.

#### What Gitea Provides

- **Web Interface**: Browse repositories, view commits, manage branches
- **Issue Tracking**: Create and manage issues for your projects
- **Pull Requests**: Collaborate with team members on code reviews
- **Wiki**: Document your projects with built-in wiki pages
- **User Management**: Create multiple user accounts for different projects
- **SSH and HTTP Access**: Clone and push repositories using your preferred protocol

#### Gitea Installation Details

The script sets up Gitea with the following configuration:

| Component | Configuration |
|-----------|---------------|
| Binary Location | `/usr/local/bin/gitea` |
| Data Directory | `/var/lib/gitea/` |
| Configuration | `/etc/gitea/app.ini` |
| System User | `git` (system account) |
| Database | MySQL (`gitea` database) |
| Service Port | 3000 (internal) |

#### Apache Reverse Proxy (Optional)

When enabled, the script configures Apache to proxy requests from `gitea.test` to Gitea's internal port. This provides:

- Clean URL access: `http://gitea.test` instead of `http://localhost:3000`
- Integration with your existing Apache setup
- Automatic hosts file modification

#### Accessing Gitea

```bash
# Direct access (port 3000)
http://localhost:3000

# Via Apache proxy (if configured)
http://gitea.test
```

**First-Time Setup**: On first access, you'll be guided through an initial configuration screen. Use the following database settings:

- Database Type: MySQL
- Host: `localhost:3306`
- Username: `gitea`
- Password: `gitea_local_password`
- Database: `gitea`

### Virtual Host Maker

The Virtual Host Maker is a utility script that simplifies the creation of Apache virtual hosts for local development. It automates the process of:

- Creating Apache configuration files
- Setting up local domains in `/etc/hosts`
- Enabling sites with `a2ensite`
- Reloading Apache configuration

#### Usage

```bash
# Create a new virtual host
sudo make_vhost

# Follow the interactive prompts
# Example: Create a site for "myproject.test"
```

The tool is installed system-wide and can be run from any terminal location.

---

## Configuration Details

### Permission Structure

The script implements a secure permission structure for web development:

| Directory | Owner | Group | Permissions |
|-----------|-------|-------|-------------|
| `/var/www/html` | `$USER` | `www-data` | Directories: 2775 |
| `/var/www/html` | `$USER` | `www-data` | Files: 0664 |
| `/var/lib/gitea` | `git` | `git` | 750 |
| `/etc/gitea` | `root` | `git` | 770 |

The `2775` permission on directories enables setgid, ensuring new files inherit the `www-data` group. This allows both your user and the web server to read/write files without permission conflicts.

### Systemd Service

Gitea runs as a systemd service with the following configuration:

```ini
[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target network.target mysql.service

[Service]
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea

[Install]
WantedBy=multi-user.target
```

#### Managing the Gitea Service

```bash
# Check service status
sudo systemctl status gitea

# Stop Gitea
sudo systemctl stop gitea

# Start Gitea
sudo systemctl start gitea

# Restart Gitea
sudo systemctl restart gitea

# View logs
sudo journalctl -u gitea -f
```

### Hosts File Modifications

If you enable the Apache reverse proxy for Gitea, the script adds:

```
127.0.0.1    gitea.test
```

This maps the local domain to your machine, allowing you to access Gitea via a clean URL.

---

## Post-Installation Steps

### 1. Restart Your Session

```bash
# Log out and log back in, or reboot
sudo reboot
```

This ensures group membership changes (adding your user to `www-data`) take effect.

### 2. Verify Installations

```bash
# Check Apache
apache2 -v
# Expected: Apache/2.4.x

# Check MySQL
mysql --version
# Expected: mysql Ver 8.x

# Check PHP
php -v
# Expected: PHP 8.x

# Check Node.js
node --version
# Expected: v20.x.x

# Check Gitea (if installed)
gitea --version
# Expected: Gitea version 1.22.0
```

### 3. Test Web Server

Create a test PHP file:

```bash
echo "<?php phpinfo(); ?>" | tee /var/www/html/info.php
```

Visit `http://localhost/info.php` to verify PHP is working correctly. **Delete this file after testing** to avoid exposing system information.

### 4. Secure MySQL (Optional but Recommended)

```bash
sudo mysql_secure_installation
```

This interactive script helps you:
- Set a root password
- Remove anonymous users
- Disallow remote root login
- Remove test database

### 5. Configure Git (If Using Gitea)

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

---

## Troubleshooting

### Common Issues and Solutions

#### Permission Denied in /var/www/html

**Symptoms**: Cannot create or modify files in the web directory.

**Solution**:
```bash
# Verify group membership
groups $USER

# If www-data is not listed, add it manually
sudo usermod -aG www-data $USER

# Log out and back in
```

#### MySQL Access Denied for Root

**Symptoms**: `Access denied for user 'root'@'localhost'`

**Solution**:
```bash
# Use sudo for root access
sudo mysql -u root

# If you need password authentication, run inside MySQL:
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_password';
FLUSH PRIVILEGES;
```

#### Gitea Service Not Starting

**Symptoms**: Gitea fails to start or shows connection errors.

**Solution**:
```bash
# Check service logs
sudo journalctl -u gitea -n 50

# Verify MySQL is running
sudo systemctl status mysql

# Check if port 3000 is available
sudo netstat -tlnp | grep 3000
```

#### Apache Not Serving PHP Files

**Symptoms**: PHP files download instead of executing.

**Solution**:
```bash
# Enable PHP module
sudo a2enmod php8.3  # Replace with your PHP version

# Restart Apache
sudo systemctl restart apache2
```

#### AdminerEvo Shows Blank Page

**Symptoms**: Accessing `/adminer` shows a blank page.

**Solution**:
```bash
# Check PHP MySQL extension
php -m | grep mysql

# Restart Apache
sudo systemctl restart apache2

# Check Apache error logs
sudo tail -f /var/log/apache2/error.log
```

---

## Contributing

Contributions are welcome! Here's how you can help improve this script:

### Reporting Issues

If you encounter a bug or have a feature request:

1. Check existing issues to avoid duplicates
2. Create a new issue with:
   - Your OS version (`lsb_release -a`)
   - Steps to reproduce
   - Expected vs. actual behavior
   - Relevant log output

### Submitting Changes

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes with clear commit messages
4. Test thoroughly on a clean system
5. Submit a pull request

### Code Style Guidelines

- Use clear, descriptive variable names
- Comment complex operations
- Follow existing formatting conventions
- Test interactive prompts for edge cases

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Available for hire!

Contact me for your web development needs!

---

<p align="center">
  <strong>Happy Coding! 🎉</strong>
</p>

<p align="center">
  If this script helped you, consider giving it a ⭐ on GitHub!
</p>
