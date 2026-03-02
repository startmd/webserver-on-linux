#!/bin/bash

# ==========================================
# MASTER DEV ENVIRONMENT SETUP SCRIPT
# OS: Linux Mint / Ubuntu
# Stack: Apache2, MySQL, PHP, Node.js
# Tools: Pulsar, Geany, AdminerEvo, Gitea
# ==========================================

# 1. Root Privilege Check
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run this script as root: sudo ./setup_dev_env.sh"
  exit
fi

# Determine the actual non-root user running sudo
ACTUAL_USER=${SUDO_USER:-$USER}

echo "========================================="
echo "🚀 MASTER DEV ENVIRONMENT SETUP"
echo "========================================="

# Helper function for yes/no prompts
ask_permission() {
    read -p "❓ $1 [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# ==========================================
# STEP 1: Interactive Configuration
# ==========================================
echo "Please configure your environment variables:"

INSTALL_PHP=false
if ask_permission "Do you want to install PHP?"; then
    INSTALL_PHP=true
    read -p "Enter the PHP version to install (e.g., 8.1, 8.2, 8.3): " PHP_VER
fi

CREATE_MYSQL_USER=false
if ask_permission "Do you want to create a master MySQL development user?"; then
    CREATE_MYSQL_USER=true
    read -p "Enter a new MySQL username for local development: " MYSQL_DEV_USER
    read -s -p "Enter the password for MySQL user '$MYSQL_DEV_USER': " MYSQL_DEV_PASS
    echo "" # For newline after silent password prompt
fi

# ==========================================
# STEP 2: Add Repositories
# ==========================================
if ask_permission "Add third-party repositories (PHP, Node.js, Pulsar)?"; then
    echo -e "\n📦 Adding Repositories..."
    apt update
    apt install -y software-properties-common curl wget git unzip ca-certificates apt-transport-https

    # PHP (Ondrej PPA)
    if [ "$INSTALL_PHP" = true ]; then
        add-apt-repository ppa:ondrej/php -y
    fi

    # Node.js (NodeSource 20.x LTS)
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

    # Pulsar Editor
    curl -sL https://pulsar-edit.dev/api/files/pulsar.gpg | sudo install -o root -g root -m 644 /dev/stdin /etc/apt/keyrings/pulsar.gpg
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/pulsar.gpg] https://pulsar-edit.dev/api/files/apt/ pulsar main" | sudo tee /etc/apt/sources.list.d/pulsar.list

    apt update
fi

# ==========================================
# STEP 3: Install Core Stack & Editors
# ==========================================
if ask_permission "Install Apache, MySQL Server, Node.js, and Editors?"; then
    echo -e "\n💻 Installing Core Stack & Editors..."
    apt install -y apache2 mysql-server nodejs geany pulsar
fi

if [ "$INSTALL_PHP" = true ]; then
    echo -e "\n🐘 Installing PHP $PHP_VER and extensions..."
    apt install -y php${PHP_VER} libapache2-mod-php${PHP_VER} \
        php${PHP_VER}-{cli,common,mysql,zip,gd,mbstring,curl,xml,bcmath,intl}
fi

# ==========================================
# STEP 4: Configure Permissions
# ==========================================
if ask_permission "Configure web directory permissions (/var/www/html)?"; then
    echo -e "\n🔐 Configuring Permissions..."
    usermod -aG www-data "$ACTUAL_USER"
    chown -R "$ACTUAL_USER":www-data /var/www/html
    find /var/www/html -type d -exec chmod 2775 {} \;
    find /var/www/html -type f -exec chmod 0664 {} \;
fi

# ==========================================
# STEP 5: MySQL Configuration
# ==========================================
if [ "$CREATE_MYSQL_USER" = true ]; then
    echo -e "\n🗄️ Configuring MySQL Dev User..."
    mysql -u root <<EOF
CREATE USER IF NOT EXISTS '${MYSQL_DEV_USER}'@'localhost' IDENTIFIED BY '${MYSQL_DEV_PASS}';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_DEV_USER}'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
fi

# ==========================================
# STEP 6: Virtual Host Maker Script
# ==========================================
if ask_permission "Install the Virtual Host Maker tool (make_vhost)?"; then
    echo -e "\n🌐 Installing Virtual Host Maker..."
    wget -qO /usr/local/bin/make_vhost https://raw.githubusercontent.com/startmd/virtual-host-maker/main/make_vhost.sh
    chmod +x /usr/local/bin/make_vhost
    echo "  -> Installed system-wide as 'make_vhost'"
fi

# ==========================================
# STEP 7: AdminerEvo Setup
# ==========================================
if ask_permission "Install AdminerEvo?"; then
    echo -e "\n🛠️ Setting up AdminerEvo..."
    ADMINER_DIR="/var/www/html/adminer"
    mkdir -p "$ADMINER_DIR"
    wget -qO "$ADMINER_DIR/index.php" https://github.com/adminerevo/adminerevo/releases/latest/download/adminer.php
    chown -R "$ACTUAL_USER":www-data "$ADMINER_DIR"
    echo "  -> AdminerEvo installed at http://localhost/adminer"
fi

# ==========================================
# STEP 8: Gitea Installation & Service
# ==========================================
if ask_permission "Install Gitea (Self-hosted Git)?"; then
    echo -e "\n🍵 Installing Gitea..."
    
    # Prepare Gitea Database
    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS gitea CHARACTER SET 'utf8mb4' COLLATE 'utf8mb4_unicode_ci';
CREATE USER IF NOT EXISTS 'gitea'@'localhost' IDENTIFIED BY 'gitea_local_password';
GRANT ALL PRIVILEGES ON gitea.* TO 'gitea'@'localhost';
FLUSH PRIVILEGES;
EOF

    if ! id -u git > /dev/null 2>&1; then
        adduser --system --shell /bin/bash --gecos 'Git Version Control' --group --disabled-password --home /home/git git
    fi

    wget -qO /usr/local/bin/gitea https://dl.gitea.com/gitea/1.22.0/gitea-1.22.0-linux-amd64
    chmod +x /usr/local/bin/gitea

    mkdir -p /var/lib/gitea/{custom,data,log}
    chown -R git:git /var/lib/gitea/
    chmod -R 750 /var/lib/gitea/

    mkdir -p /etc/gitea
    chown root:git /etc/gitea
    chmod 770 /etc/gitea

    cat > /etc/systemd/system/gitea.service <<EOF
[Unit]
Description=Gitea (Git with a cup of tea)
After=syslog.target
After=network.target
After=mysql.service

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
EOF

    systemctl daemon-reload
    systemctl enable --now gitea

    # Apache Proxy for Gitea
    if ask_permission "Setup Apache Reverse Proxy for gitea.test?"; then
        a2enmod proxy proxy_http rewrite > /dev/null 2>&1
        cat > /etc/apache2/sites-available/gitea.test.conf <<EOF
<VirtualHost *:80>
    ServerName gitea.test
    ProxyPreserveHost On
    ProxyPass / http://127.0.0.1:3000/
    ProxyPassReverse / http://127.0.0.1:3000/
</VirtualHost>
EOF
        if ! grep -q "gitea.test" /etc/hosts; then
            echo "127.0.0.1    gitea.test" >> /etc/hosts
        fi
        a2ensite gitea.test.conf > /dev/null 2>&1
        systemctl restart apache2
    fi
fi

echo "========================================="
echo "✅ PROCESS COMPLETE!"
echo "========================================="
echo "⚠️  IMPORTANT: Please log out and log back in (or reboot) if you"
echo "modified group permissions for the changes to take effect."
