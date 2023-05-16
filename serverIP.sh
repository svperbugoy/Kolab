########################################################################################
# Display SERVER IP
echo "" >> /etc/issue
echo eth0: "\4{enp0s3}" >> /etc/issue
echo "IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')" >> /etc/rc.local
echo ""eth0 IP: $IP" > /etc/issue" >> /etc/rc.local
echo "IP Displayed"
########################################################################################

sudo reboot
