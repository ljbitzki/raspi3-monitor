#!/bin/bash
GPATH="/var/www/html/graphs"
cp graphs.sh /etc
chmod +x graphs.sh
mkdir -p $GPATH/{csv,assets}
cp index.php base $GPATH

chown www-data:www:data $GPATH -R
