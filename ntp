#!/bin/bash
/etc/init.d/ntp stop
until ping -nq -c3 8.8.8.8; do
   echo "Aguardando rede..."
done
ntpdate 200.160.0.8
/etc/init.d/ntp start
