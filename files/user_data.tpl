#!/bin/bash

# Resize /tmp for Jenkins
lsof +D /tmp
umount /tmp
mount -t tmpfs -o size=10G tmpfs /tmp
mount -o remount,size=10G /tmp

# Copy the required Jenkins files from S3 bucket
aws s3 cp s3://${bucket_name}/initJenkins.groovy /tmp
aws s3 cp s3://${bucket_name}/plugins.txt /tmp

# Import Jenkins repository key
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Update package repositories
yum update -y

# Install Jenkins
yum install java-21-amazon-corretto-devel jenkins git -y

# Install Terraform
curl -sL https://releases.hashicorp.com/terraform/${terraform_version}/terraform_${terraform_version}_linux_amd64.zip -o terraform.zip
unzip terraform.zip
mv terraform /usr/bin/
rm terraform.zip

# Move groovy script prior to starting Jenkins
mkdir /var/lib/jenkins/init.groovy.d
mv /tmp/initJenkins.groovy /var/lib/jenkins/init.groovy.d/

# Change permissions on new directories and files
chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d

# Skip setup wizard
export JAVA_OPTS='-Djenkins.install.runSetupWizard=false'

# Enable Jenkins service to start on boot
systemctl enable jenkins

# Start Jenkins service
systemctl start jenkins

# Download Jenkins CLI JAR
wget http://localhost:8080/jnlpJars/jenkins-cli.jar

# Place the JAR file in a suitable Location
mv jenkins-cli.jar /usr/local/bin

# Ensure proper permissions
chmod +x /usr/local/bin/jenkins-cli.jar

# Read the plugin list from file and install plugins
java -jar /usr/local/bin/jenkins-cli.jar -s http://localhost:8080 -auth "${admin_username}:${admin_password}" install-plugin $(cat /tmp/plugins.txt)

# Restart Jenkins after installing plugins
java -jar /usr/local/bin/jenkins-cli.jar -s http://localhost:8080 -auth "${admin_username}:${admin_password}" safe-restart