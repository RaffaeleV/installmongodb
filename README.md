# installmongodb

Project Description
===================
This Bash script automates the installation and configuration of MongoDB on a Rocky Linux system.
It sets up a replica set and creates an administrative user to access MongoDB.

Key Features
============
MongoDB Installation: The script adds the MongoDB repository and installs MongoDB version 8.0 using the dnf package manager.

Firewall Configuration: It adds a firewall rule to allow traffic on MongoDB's default TCP port (27017).

MongoDB Service Setup: It enables and starts the MongoDB service using systemctl.

Replica Set Configuration: It modifies the mongod.conf configuration file to enable the replica set, setting the replica set name (default is rs0).

Bind IP Configuration: The script configures MongoDB to accept connections from a specified IP address.

Replica Set Initialization: It initializes the replica set using the rs.initiate() command in MongoDB.

Admin User Creation: The script creates an admin user with root privileges in the admin database.

Prerequisites
=============
Rocky Linux (or other RHEL-based distributions)

dnf as the package manager

Sudo access for installation and configuration

Usage Instructions
==================
Create the script:
  nano installmongo.sh

Paste the content of the script into the file.

Make the script executable:

  chmod +x installmongo.sh

Run the script:

  ./installmongo.sh

This script is intended for use in test or development environments. Modifications may be required for production environments, such as secure password management or advanced security configurations.

Notes
=====
The replica set name and admin user credentials are configurable by editing the variables at the top of the script.






