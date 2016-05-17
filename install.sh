#!/bin/bash
apt-get update
apt-get install vim ntpdate apache2 php5 bc dnsutils sysstat -y

GPATH="/var/www/html/graphs"
cp graphs.sh ntp.sh /etc
chmod +x /etc/{graphs.sh,ntp.sh}

sed -i '$ d' /etc/crontab
echo -e '*  *    * * *   root    /etc/graphs.sh
#' >> /etc/crontab

sed -i '$ d' /etc/rc.local
echo -e '/etc/ntp &
exit 0' >> /etc/rc.local

mkdir -p $GPATH/{csv,assets}
cp graphs/{index.php,base} $GPATH
chown www-data:www:data $GPATH -R

echo "Instalation completed!"
echo "Reboot your Pi..."
