#!/bin/bash
set -e

SONAR_VERSION="9.9.3.79811"
SONAR_USER="sonar"
SONAR_HOME="/opt/sonarqube"
DB_NAME="sonarqube"
DB_USER="sonar"
DB_PASSWORD="sonar"

echo "=== SonarQube Installation Script ==="
echo ""
echo "Select your OS:"
echo "1) Ubuntu / Debian-based"
echo "2) Amazon Linux 2"
echo ""

read -p "Enter choice [1 or 2]: " OS_CHOICE

install_packages_ubuntu() {
  sudo apt update
  sudo apt install -y openjdk-17-jdk unzip wget postgresql postgresql-contrib
}

install_packages_amazon() {
  sudo yum update -y
  sudo amazon-linux-extras install java-openjdk17 -y
  sudo yum install -y unzip wget postgresql-server postgresql-contrib
  sudo postgresql-setup initdb
  sudo systemctl enable postgresql
  sudo systemctl start postgresql
}

echo ""
echo "Installing OS packages..."

case "$OS_CHOICE" in
  1)
    install_packages_ubuntu
    ;;
  2)
    install_packages_amazon
    ;;
  *)
    echo "Invalid choice"
    exit 1
    ;;
esac

echo ""
echo "Configuring PostgreSQL..."

sudo systemctl enable postgresql
sudo systemctl start postgresql

sudo -u postgres psql <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER WITH ENCRYPTED PASSWORD '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
EOF

echo ""
echo "Creating sonar user..."

sudo useradd --system --no-create-home --shell /bin/bash $SONAR_USER || true

echo ""
echo "Downloading SonarQube..."

cd /tmp
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip
sudo unzip sonarqube-$SONAR_VERSION.zip -d /opt
sudo mv /opt/sonarqube-$SONAR_VERSION $SONAR_HOME
sudo chown -R $SONAR_USER:$SONAR_USER $SONAR_HOME

echo ""
echo "Configuring SonarQube..."

sudo sed -i "s|#sonar.jdbc.username=|sonar.jdbc.username=$DB_USER|" $SONAR_HOME/conf/sonar.properties
sudo sed -i "s|#sonar.jdbc.password=|sonar.jdbc.password=$DB_PASSWORD|" $SONAR_HOME/conf/sonar.properties
sudo sed -i "s|#sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube|sonar.jdbc.url=jdbc:postgresql://localhost/$DB_NAME|" $SONAR_HOME/conf/sonar.properties

sudo sed -i "s|#RUN_AS_USER=|RUN_AS_USER=$SONAR_USER|" $SONAR_HOME/bin/linux-x86-64/sonar.sh

echo ""
echo "Creating systemd service..."

sudo tee /etc/systemd/system/sonarqube.service > /dev/null <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target postgresql.service

[Service]
Type=forking
ExecStart=$SONAR_HOME/bin/linux-x86-64/sonar.sh start
ExecStop=$SONAR_HOME/bin/linux-x86-64/sonar.sh stop
User=$SONAR_USER
Group=$SONAR_USER
Restart=always
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable sonarqube
sudo systemctl start sonarqube

echo ""
echo "SonarQube installation completed."
echo ""
echo "Access SonarQube at:"
echo "  http://<your-server-ip>:9000"
echo ""
echo "Default credentials:"
echo "  username: admin"
echo "  password: admin"