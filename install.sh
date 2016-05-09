#!/bin/bash
GPATH="/var/www/html/graphs"
cp graphs.sh ntp.sh /etc
chmod +x /etc/{graphs.sh,ntp.sh}

sed -i '$ d' /etc/crontab
echo '
*  *    * * *   root    /etc/graphs.sh
#
' >> /etc/crontab
/etc/init.d/crontab restart
mkdir -p $GPATH/{csv,assets}
cp index.php base $GPATH
chown www-data:www:data $GPATH -R
