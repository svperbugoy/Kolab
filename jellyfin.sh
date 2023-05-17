########################################################################################
# Media Server - JELLYFIN
##
##
sudo apt update && sudo apt upgrade -y
sudo apt install apt-transport-https ca-certificates gnupg2 curl git -y
sudo wget -O- https://repo.jellyfin.org/jellyfin_team.gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/jellyfin.gpg
##
# JELLYFIN - REPOSITORIES
##
echo "deb [arch=$( dpkg --print-architecture ) signed-by=/usr/share/keyrings/jellyfin.gpg] https://repo.jellyfin.org/debian bullseye main" | sudo tee /etc/apt/sources.list.d/jellyfin.list
echo "deb [arch=$( dpkg --print-architecture ) signed-by=/usr/share/keyrings/jellyfin.gpg] https://repo.jellyfin.org/debian bullseye main unstable" | sudo tee /etc/apt/sources.list.d/jellyfin.list
##
# JELLYFIN - UPDATE/INSTALL
##
sudo apt update
sudo apt install jellyfin -y
sudo systemctl start jellyfin
sudo systemctl enable jellyfin
echo "JellyFin Installed"
########################################################################################

sudo reboot
