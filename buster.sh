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
docker run -d -p 8000:8000 -p 9443:9443 -p 9000:9000 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
echo "Portainer Installed"
########################################################################################

########################################################################################
# Install COCKPIT (9090)
apt-get update && apt-get upgrade
apt-get install cockpit -y
echo "Cockpit Installed"
########################################################################################

########################################################################################
# Install Filebrowser (9080)
docker volume create filebrowser
docker run -d -p 9080:80 --name filebrowser --restart=unless-stopped -v ~/:/srv -v ~/filebrowser/filebrowser.db:/database/filebrowser.db -v ~/filebrowser/settings.json:/config/settings.json -e TZ=Asia/Dubai -e PUID=1000 -e PGID=1000 filebrowser/filebrowser:latest

echo "Filebrowser Installed"
########################################################################################

########################################################################################
# Install Nginx Proxy (40081)
docker volume create nginx-proxy
docker run -d -p 40080:80 -p 40443:443 -p 40081:81 --name nginx-proxy --restart=unless-stopped -v ./data:/data -v ./letsencrypt:/etc/letsencrypt jc21/nginx-proxy-manager:latest
echo "Nginx Proxy Installed"
########################################################################################


########################################################################################
# Display SERVER IP
##
##
FILE="/etc/issue"
ip=$(ip addr | grep inet.*brd | sed 's/^.*inet //;s/ brd.*$//;s/^//;2,$ d')
echo "$(lsb_release -d | cut -d":" -f2 | sed 's/^\s//') \n \l" > $FILE
echo "IP: $ip" >> $FILE
echo "" >> $FILE
echo "IP Displayed"
########################################################################################

sudo reboot
