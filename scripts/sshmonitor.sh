#!/bin/bash
database="/root/usuarios.db"
fun_drop () {
port_dropbear=`ps aux | grep dropbear | awk NR==1 | awk '{print $17;}'`
log=/var/log/auth.log
loginsukses='Password auth succeeded'
clear
pids=`ps ax |grep dropbear |grep  " $port_dropbear" |awk -F" " '{print $1}'`
for pid in $pids
do
    pidlogs=`grep $pid $log |grep "$loginsukses" |awk -F" " '{print $3}'`
    i=0
    for pidend in $pidlogs
    do
      let i=i+1
    done
    if [ $pidend ];then
       login=`grep $pid $log |grep "$pidend" |grep "$loginsukses"`
       PID=$pid
       user=`echo $login |awk -F" " '{print $10}' | sed -r "s/'/ /g"`
       waktu=`echo $login |awk -F" " '{print $2"-"$1,$3}'`
       while [ ${#waktu} -lt 13 ]; do
           waktu=$waktu" "
       done
       while [ ${#user} -lt 16 ]; do
           user=$user" "
       done
       while [ ${#PID} -lt 8 ]; do
           PID=$PID" "
       done
       echo "$user $PID $waktu"
    fi
done
}
echo $$ > /tmp/kids
while true
do

	while read usline
	do
		user="$(echo $usline | cut -d' ' -f1)"
		s2ssh="$(echo $usline | cut -d' ' -f2)"
		if [[ -e /etc/openvpn/openvpn-status.log ]]; then
        ovp="$(cat /etc/openvpn/openvpn-status.log | grep -E ,"$user", | wc -l)"
        else
        ovp=0
        fi
        if netstat -nltp|grep 'dropbear'> /dev/null;then
          drop="$(fun_drop | grep "$user" | wc -l)"
        else
          drop=0
        fi
        cnx=$(($sqd + $drop))
        conex=$(($cnx + $ovp))
		if [ -z "$user" ] ; then
			echo "" > /dev/null
		else
			ps x | grep [[:space:]]$user[[:space:]] | grep -v grep | grep -v pts > /tmp/tmp8
			s1ssh="$(cat /tmp/tmp8 | wc -l)"
			conex=$(($s1ssh + $ovp + $sqd + $drop))
			tput setaf 3 ; tput bold ; printf '  %-35s%s\n' $user,$conex,; tput sgr0
		fi
	done < "$database"
	echo ""
	exit 1
done
