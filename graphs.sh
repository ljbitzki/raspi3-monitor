#!/bin/bash
HM=$(date +"%H:%M")
AMD=$(date +"%Y-%m-%d")
PATHG="/var/www/html/graphs"
UPT=$(uptime -p | sed "s/up //g")

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
CPUIDLE=$(mpstat | tail -1 | awk '{print $12}' | sed s/,/./g)
CPUUSER=$(mpstat | tail -1 | awk '{print $3}' | sed s/,/./g)
CPUSYSTEM=$(mpstat | tail -1 | awk '{print $5}' | sed s/,/./g)

# Disco
FREE1=$(df -h | grep 'root' | cut -d 'G' -f3 | tr -d ' ' | sed s/,/./g)
FREE2=$(df -h | grep 'sda1' | cut -d 'G' -f3 | tr -d ' ' | sed s/,/./g)
USED1=$(df -h | grep 'root' | cut -d 'G' -f2 | tr -d ' ' | sed s/,/./g)
USED2=$(df -h | grep 'sda1' | cut -d 'G' -f2 | tr -d ' ' | sed s/,/./g)

# Arquivos
GRAPHT="$PATHG/csv/$AMD-temp.csv"
GRAPHM="$PATHG/csv/$AMD-mem.csv"
GRAPHC="$PATHG/csv/$AMD-cpu.csv"
GRAPHD1="$PATHG/csv/$AMD-disk1.csv"
GRAPHD2="$PATHG/csv/$AMD-disk2.csv"
GRAPHNQ="$PATHG/csv/$AMD-netq.csv"
GRAPHNU="$PATHG/csv/$AMD-netu.csv"
INDEX="$PATHG/$AMD-index.php"

if [[ -e $INDEX ]]; then
   wait
        cp $PATHG/base $INDEX
        sed -i "s/TX/$SEDT/g" $INDEX
        sed -i "s/RX/$SEDR/g" $INDEX
        sed -i "s/AMD/$AMD/g" $INDEX
	sed -i "s/UPT/$UPT/g" $INDEX
        echo "$HM,$TEMPM,$TEMPC,$TEMPA" >> $GRAPHT
        echo "$HM,$MEMT,$MEMA,$MEMC" >> $GRAPHM
        echo "$HM,$CPUIDLE,$CPUUSER,$CPUSYSTEM" >> $GRAPHC
        echo "$HM,$USED1,$FREE1" >> $GRAPHD1
        echo "$HM,$USED2,$FREE2" >> $GRAPHD2
        echo "$HM,-30,-$SNRN,70,$QLT" >> $GRAPHNQ
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
        echo "Hora,Espaco Utilizado - GB,Espaco Disponivel - GB" > $GRAPHD1
        echo "$HM,$USED1,$FREE1" >> $GRAPHD1
        echo "Hora,Espaco Utilizado - GB,Espaco Disponivel - GB" > $GRAPHD2
        echo "$HM,$USED2,$FREE2" >> $GRAPHD2
        echo "Hora,Potencia Maxima Possivel,Potencia Atual,Qualidade Maxima Possivel,Qualidade Atual" > $GRAPHNQ
        echo "$HM,-30,-$SNRN,70,$QLT" >> $GRAPHNQ
        sed -i "s/TX/$SEDT/g" $INDEX
        sed -i "s/RX/$SEDR/g" $INDEX
	sed -i "s/UPT/$UPT/g" $INDEX
    wait
        chown www-data:www-data $PATHG/csv/* /$PATHG/*.php
   fi
