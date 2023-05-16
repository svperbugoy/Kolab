#!/bin/bash

########################################################################################
# Check if user has root privileges
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
########################################################################################

########################################################################################
# Updating and Upgrading the system
apt-get update 
apt-get upgrade
apt-get install net-tools -y
apt-get install ufw -y
########################################################################################

########################################################################################
# Add SUDO
echo "" >> /etc/sudoers
echo "# This was added from the install.sh" >> /etc/sudoers
echo "bugoy    ALL=(ALL:ALL) ALL" >> /etc/sudoers
echo "Added sudoers"
########################################################################################

########################################################################################
# Disabling the GUI
systemctl set-default multi-user.target
########################################################################################

########################################################################################
# Disabling the CLOSE LID
echo "" >> /etc/systemd/logind.conf
echo "# This was added from the install.sh" >> /etc/systemd/logind.conf
echo "HandleLidSwitch=ignore" >> /etc/systemd/logind.conf
echo "HandleLidSwitchExternalPower=ignore" >> /etc/systemd/logind.conf
echo "HandleLidSwitchDocked=ignore" >> /etc/systemd/logind.conf
echo "Disabled laptop close lid"
########################################################################################

########################################################################################
# Firewall Stuff
# apt install ufw
ufw allow 22
########################################################################################

########################################################################################
echo "" >> /etc/systemd/logind.conf
echo "# This was added from the install.sh" >> /etc/systemd/logind.conf
echo "HandleLidSwitch=ignore" >> /etc/systemd/logind.conf
echo "HandleLidSwitchExternalPower=ignore" >> /etc/systemd/logind.conf
echo "HandleLidSwitchDocked=ignore" >> /etc/systemd/logind.conf
echo "Disabled laptop close lid"
########################################################################################

########################################################################################
echo "" >> /etc/ssh/sshd_config
echo "# This was added from the install.sh" >> /etc/ssh/sshd_config
echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo "SSH enabled"
########################################################################################

########################################################################################
# Install DOCKER (Native)
apt-get update
apt-get install ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
apt-get install docker -y
echo "Docker Installed"
########################################################################################

########################################################################################
# Install PORTAINER (9000)
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9443:9443 -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ee:latest
echo "Portainer Installed"
########################################################################################

Sudo reboot


