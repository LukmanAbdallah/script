#!/bin/bash

# Set hostname
sudo hostnamectl set-hostname maven

# Update system and install base tools
sudo apt update -y
sudo apt install wget unzip tree git -y

# Try to install OpenJDK 11
if sudo apt install -y openjdk-11-jdk; then
    JAVA_PATH="/usr/lib/jvm/java-11-openjdk-amd64"
    echo "OpenJDK 11 installed successfully."
else
    echo "OpenJDK install failed. Installing Amazon Corretto 11..."
    sudo apt install -y curl gnupg
    curl -fsSL https://apt.corretto.aws/corretto.key | gpg --dearmor | sudo tee /usr/share/keyrings/corretto-keyring.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list
    sudo apt update -y
    sudo apt install -y java-11-amazon-corretto-jdk
    JAVA_PATH="/usr/lib/jvm/java-11-amazon-corretto"
fi

# Go to /opt directory
cd /opt

# Download and extract Maven
wget https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.zip
unzip apache-maven-3.9.11-bin.zip
rm -f apache-maven-3.9.11-bin.zip
sudo mv apache-maven-3.9.11 /opt/maven

# Set environment variables for ubuntu user
echo "" >> /home/ubuntu/.bashrc
echo "# Java and Maven environment variables" >> /home/ubuntu/.bashrc
echo "export JAVA_HOME=$JAVA_PATH" >> /home/ubuntu/.bashrc
echo "export M2_HOME=/opt/maven" >> /home/ubuntu/.bashrc
echo "export PATH=\$JAVA_HOME/bin:\$M2_HOME/bin:\$PATH" >> /home/ubuntu/.bashrc

# Apply changes immediately
sudo chown ubuntu:ubuntu /home/ubuntu/.bashrc
sudo -u ubuntu bash -c "source /home/ubuntu/.bashrc"

echo "✅ Setup complete for Ubuntu. Java and Maven are ready."
