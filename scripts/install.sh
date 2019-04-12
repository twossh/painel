#!/bin/bash
wget https://raw.githubusercontent.com/twossh/SSHPLUS-MANAGER-FREE/master/Install/lista > /dev/null 2>&1
wget https://raw.githubusercontent.com/twossh/SSHPLUS-MANAGER-FREE/master/versao -O /bin/versao > /dev/null 2>&1
wget https://raw.githubusercontent.com/twossh/SSHPLUS-MANAGER-FREE/master/Install/licence -O /usr/lib/licence > /dev/null 2>&1
clear
[[ "$EUID" -ne 0 ]] && echo -e "\033[1;33mDesculpe, \033[1;33mvocê precisa executar como root\033[0m" && rm -rf $HOME/Plus > /dev/null 2>&1 && return 1
cd $HOME
fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} -y > /dev/null 2>&1
${comando[1]} -y > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
done
tput cnorm
}

tput setaf 7 ; tput setab 4 ; tput bold ; printf '%40s%s%-12s\n' "BEM VINDO AO SSHPLUS MANAGER" ; tput sgr0
chmod +x lista; ./lista > /dev/null 2>&1
sleep 2
IP=$(wget -qO- ipv4.icanhazip.com)
echo "$IP" >/etc/IP
if [ -z "$" ]; then
  echo ""
  echo -e "\033[1;31mErro \033[1;32mIP incorreto!\033[0m"
  rm -rf $HOME/Plus root/lista > /dev/null 2>&1
  sleep 2
  clear; exit 1
fi
clear
fun_attlist () {
    apt-get update -y
    apt-get upgrade -y
    apt-get autoremove -y
    apt-get install -f
    if service apache2 status; then
    sed -i "s/Listen 80/Listen 81/g" /etc/apache2/ports.conf
    service apache2 restart
	/etc/init.d/apache2 restart
    fi
}
fun_bar 'fun_attlist'
sleep 1
clear
inst_pct () {
apt-get install bc screen nano unzip dos2unix -y > /dev/null 2>&1
apt-get install nload -y > /dev/null 2>&1
apt-get install htop -y > /dev/null 2>&1
apt-get install jq -y > /dev/null 2>&1
apt-get install lsof -y > /dev/null 2>&1
apt-get install curl -y > /dev/null 2>&1
apt-get install figlet -y > /dev/null 2>&1
apt-get install python -y > /dev/null 2>&1
apt-get install python3 -y > /dev/null 2>&1
apt-get install python-pip -y > /dev/null 2>&1
pip install speedtest-cli > /dev/null 2>&1
}
fun_bar 'inst_pct'
sleep 1
if [ -f "/usr/sbin/ufw" ] ; then
  ufw allow 443/tcp ; ufw allow 80/tcp ; ufw allow 3128/tcp ; ufw allow 8799/tcp ; ufw allow 8080/tcp
fi
clear
cd /root
fun_bar 'source list'
rm install* > /dev/null 2>&1
touch /root/usuarios.db
sleep 1
cat /dev/null > ~/.bash_history && history -c && clear
service ssh restart > /dev/null 2>&1
cd $HOME
if [[ "$optiondb" = '2' ]]; then
  awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > $HOME/usuarios.db
fi
