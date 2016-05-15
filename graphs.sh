#!/bin/bash
HM=$(date +"%H:%M")
AMD=$(date +"%Y-%m-%d")
PATHG="/var/www/html/graphs"

# Temperatura
TEMP=$(/opt/vc/bin/vcgencmd measure_temp | cut -d '=' -f2)
TEMPA=${TEMP::-2}
TEMPC="60"
TEMPM="75"

# Memória
MEMTTMP=$(cat /proc/meminfo | grep MemTotal: | sed 's|[^0-9]||g')
MEMT=$(echo "scale=2;$MEMTTMP / 1024" | bc )
MEMATMP=$(cat /proc/meminfo | grep MemAvailable: | sed 's|[^0-9]||g')
MEMA=$(echo "scale=2;$MEMATMP / 1024" | bc )
MEMCTMP=$(cat /proc/meminfo | grep -w 'Cached:' | sed 's|[^0-9]||g')
MEMC=$(echo "scale=2;$MEMCTMP / 1024" | bc )

#Rede Qualidade
SNR=$(wavemon -d | grep 'SNR' | cut -d '-' -f2)
SNRN=${SNR::-3}
QLT=$(wavemon -d | grep 'link quality' | cut -d '/' -f1  | grep -o "[0-9][0-9]")

#Rede Trafego
RXB=$(cat /sys/class/net/wlan0/statistics/rx_bytes)
TXB=$(cat /sys/class/net/wlan0/statistics/tx_bytes)
if [ $RXB -le 1024000 ]; then
RXC=$(echo "scale=2;$RXB / 1024" | bc)
RUNI="KBytes"
elif [ $RXB -ge 1024000 ] && [ $RXB -lt 102400000 ]; then
RXC=$(echo "scale=2;$RXB / 1024 / 1024" | bc)
RUNI="MBytes"
elif [ $RXB -ge 102400000 ] && [ $RXB -lt 102400000000 ]; then
RXC=$(echo "scale=2;$RXB / 1024 / 1024 / 1024" | bc)
RUNI="GBytes"
elif [ $RXB -ge 102400000000 ] && [ $RXB -lt 102400000000000 ]; then
RXC=$(echo "scale=2;$RXB / 1024 / 1024 / 1024 / 1024" | bc)
RUNI="TBytes"
fi

if [ $TXB -le 1024000 ]; then
TXC=$(echo "scale=2;$TXB / 1024" | bc)
TUNI="KBytes"
elif [ $TXB -ge 1024000 ] && [ $TXB -lt 102400000 ]; then
TXC=$(echo "scale=2;$TXB / 1024 / 1024" | bc)
TUNI="MBytes"
elif [ $TXB -ge 102400000 ] && [ $TXB -lt 102400000000 ]; then
TXC=$(echo "scale=2;$TXB / 1024 / 1024 / 1024" | bc)
TUNI="GBytes"
elif [ $TXB -ge 102400000000 ] && [ $TXB -lt 102400000000000 ]; then
TXC=$(echo "scale=2;$TXB / 1024 / 1024 / 1024 / 1024" | bc)
TUNI="TBytes"
fi
SEDR="$(echo $RXC $RUNI)"
SEDT="$(echo $TXC $TUNI)"

# Processador
CPUIDLE=$(snmpwalk -v1 -c public 127.0.0.1 .1.3.6.1.4.1.2021.11.11.0 | cut -d ':' -f2 | cut -d ' ' -f2)
CPUUSER=$(snmpwalk -v1 -c public 127.0.0.1 .1.3.6.1.4.1.2021.11.9.0 | cut -d ':' -f2 | cut -d ' ' -f2)
CPUSYSTEM=$(snmpwalk -v1 -c public 127.0.0.1 .1.3.6.1.4.1.2021.11.10.0 | cut -d ':' -f2 | cut -d ' ' -f2)

# Disco
FREE=$(snmpwalk -v1 -c public 127.0.0.1 .1.3.6.1.4.1.2021.9.1.7.1 | cut -d ':' -f2 | cut -d ' ' -f2)
USED=$(snmpwalk -v1 -c public 127.0.0.1 .1.3.6.1.4.1.2021.9.1.8.1 | cut -d ':' -f2 | cut -d ' ' -f2)
FREEG=$(echo "scale=2;$FREE / 1024 / 1024" | bc)
USEDG=$(echo "scale=2;$USED / 1024 / 1024" | bc)

# Arquivos
GRAPHT="$PATHG/csv/$AMD-temp.csv"
GRAPHM="$PATHG/csv/$AMD-mem.csv"
GRAPHC="$PATHG/csv/$AMD-cpu.csv"
GRAPHD="$PATHG/csv/$AMD-disk.csv"
GRAPHNQ="$PATHG/csv/$AMD-netq.csv"
GRAPHNU="$PATHG/csv/$AMD-netu.csv"
INDEX="$PATHG/$AMD-index.php"

if [[ -e $INDEX ]]; then
   wait
        echo "$HM,$TEMPM,$TEMPC,$TEMPA" >> $GRAPHT
        echo "$HM,$MEMT,$MEMA,$MEMC" >> $GRAPHM
        echo "$HM,$CPUIDLE,$CPUUSER,$CPUSYSTEM" >> $GRAPHC
        echo "$HM,$USEDG,$FREEG" >> $GRAPHD
        echo "$HM,-35,-$SNRN,70,$QLT" >> $GRAPHNQ
        echo "$HM,$TXC,$RXC" >> $GRAPHNU
else
        cp $PATHG/base $INDEX
    wait
        sed -i "s/AMD/$AMD/g" $INDEX
        echo "Hora,Critico,Atencao,Temperatura Atual" > $GRAPHT
        echo "$HM,$TEMPM,$TEMPC,$TEMPA" >> $GRAPHT
        echo "Hora,Memoria Total - MB,Memoria Disponivel - MB,Memoria em Cache - MB" > $GRAPHM
        echo "$HM,$MEMT,$MEMA,$MEMC" >> $GRAPHM
        echo "Hora,CPU Idle,CPU Usuario,CPU Sistema" > $GRAPHC
        echo "$HM,$CPUIDLE,$CPUUSER,$CPUSYSTEM" >> $GRAPHC
        echo "Hora,Espaco Utilizado - GB,Espaco Disponivel - GB" > $GRAPHD
        echo "$HM,$USEDG,$FREEG" >> $GRAPHD
        echo "Hora,Potencia Maxima Possivel,Potencia Atual,Qualidade Maxima Possivel,Qualidade Atual" > $GRAPHNQ
        echo "$HM,-38,-$SNRN,70,$QLT" >> $GRAPHNQ
        sed -i "s/TX/$SEDT/g" $INDEX
        sed -i "s/RX/$SEDR/g" $INDEX
    wait
        chown www-data:www-data $PATHG/csv/* /$PATHG/*.php
   fi
