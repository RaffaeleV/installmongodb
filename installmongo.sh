#!/bin/bash


# nano installmongo.sh         # to create the installation script
# chmod +x installmongo.sh     # to enable execution of the script
# ./installmongo.sh            # to execute the script

# MongoDB variables
MONGO_VERSION="8.0"
MONGO_PORT="27017"
BIND_IP="192.168.1.128"
ADMIN_USER="mongoadmin"
ADMIN_PASS="mongo"
REPLICA_SET_NAME="rs0"

echo "Starting MongoDB installation and configuration..."

# Install MongoDB
echo "Installing MongoDB $MONGO_VERSION..."
cat > /etc/yum.repos.d/mongodb-org.repo <<EOF
[mongodb-org-${MONGO_VERSION}]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/${MONGO_VERSION}/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-${MONGO_VERSION}.asc
EOF

sudo dnf install -y mongodb-org


# Add firewall rules to allow MongoDB traffic
echo "Adding firewall rules to allow MongoDB traffic..."
sudo firewall-cmd --permanent --add-port=${MONGO_PORT}/tcp
sudo firewall-cmd --reload

# Enable and start the MongoDB service
echo "Enabling and starting MongoDB service..."
sudo systemctl enable mongod
sudo systemctl start mongod


# Enable replica set in configuration
echo "Enabling replica set configuration..."
sudo sed -i 's/^#replication:/replication:/' /etc/mongod.conf
sudo sed -i "/^replication:/a\  replSetName: \"${REPLICA_SET_NAME}\"" /etc/mongod.conf

# Configure bind IP
echo "Configuring bind IP..."
sudo sed -i "/^  bindIp:/ s/127\.0\.0\.1/127.0.0.1,${BIND_IP}/" /etc/mongod.conf

# Restart MongoDB to apply the changes
echo "Restarting MongoDB to apply changes..."
sudo systemctl restart mongod

# Wait for MongoDB to initialize
sleep 10
echo "MongoDB is ready!"

# Initialize replica set
echo "Initializing replica set..."
mongosh --host 127.0.0.1 --port ${MONGO_PORT} <<EOF
rs.initiate({
  _id: "${REPLICA_SET_NAME}",
  members: [{ _id: 0, host: "${BIND_IP}:${MONGO_PORT}" }]
})
EOF

# Create admin user
echo "Creating admin user..."

mongosh --host 127.0.0.1 --port ${MONGO_PORT} <<EOF
use admin
db.createUser({
  user: "${ADMIN_USER}",
  pwd: "${ADMIN_PASS}",
  roles: [
    { role: "root", db: "admin" }
  ]
})
EOF

echo "MongoDB installation and configuration completed successfully."
