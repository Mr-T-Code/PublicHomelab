#!/bin/bash

# Validation of userinput
validate_input() {
    # Check if username already exists
    if id "$1" &>/dev/null; then
        echo "Error: Username exists already."
        exit 1
    fi
    # Check if the password meets the minimal length
    if [ ${#2} -lt 8 ]; then
        echo "Error: Password must contain minimum 8 characters."
        exit 1
    fi
}

# Backup-functionality
create_backup() {
    echo "Creating backup..."
    # Add here the commands to copy important config files to a backup location
}

# Logging
log_action() {
    echo "$(date): $1" >> init_log.txt
}

# Request Username and Password
read -p "Please provide the username for the new user: " username
read -sp "Please provide the password for the new user: " password
echo

# Validate userinput
validate_input $username $password

# Create the new user
echo "Creating the user $username..."
sudo useradd -m $username
log_action "User '$username' created"

# Set the password of the new user
echo "Password initialisation of the user '$username'..."
echo -e "$password\n$password" | sudo passwd $username
log_action "Password set for the user '$username'"

# Add the new user to the sudo-group
echo "Adding user '$username' to the sudo-group..."
sudo usermod -aG sudo $username
log_action "User $username added to the sudo-group"

# Execute backup activities
create_backup

# Execute systemupdate
echo "Executing system update..."
sudo apt update && sudo apt upgrade -y
log_action "System update executed"

# Install basic tools
echo "Installing basic tools..."
sudo apt install -y curl net-tools nano vim htop git ufw wget tree zip unzip ssh # Add other apps here
log_action "Basic tools installed"

echo "Installation completed."
