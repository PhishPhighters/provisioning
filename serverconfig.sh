#!/bin/bash

# Script Name: Configure A Linux Ubuntu Server
# Author: Ian
# Date of Latest Revision: 14 Nov 23


############################################################################################
######################### Configure A Linux Ubuntu Server (CALUS) ##########################
############################################################################################

getname(){
    read -p "Enter the username to enable for Samba sharing on this server: " username
    echo $username
}

updater(){
    sudo apt update && sudo apt upgrade -y && echo "Upgraded system"
    sleep 1
}

app-fetcher(){
    sudo apt install cifs-utils -y && echo "Installed CIFS"
    sleep 1
    sudo apt-get install nano -y && echo "Installed nano"
    sleep 1
    sudo apt install samba -y && echo "Installed samba"
    sleep 1
    sudo apt-get install ufw -y && echo "Installed ufw"
    sleep 1
}

firewall(){
    sudo ufw allow 22 && echo "allowed SSH"
    sleep 1
    sudo ufw allow 139/tcp && sudo ufw allow 445/tcp && echo "allowed TCP fileshare 139/445"
    sleep 1
}

new_acct(){
    sudo adduser $username && echo "created user on Ubuntu with username $username"
    sleep 1
    sudo smbpasswd -a $username && echo "added $username to Samba"
    sleep 1
    sudo smbpasswd -e $username && echo "enabled $username on Samba"
    sleep 1
}

update_smbconf(){
    lines=("[shared]" "path = /home/$username" "writable = yes" "guest ok = no" "read only = no" "create mask = 0777" "directory mask = 0777"
        "server signing = mandatory" "client signing = mandatory" "passdb backend = smbpasswd")

    smb_conf="/etc/samba/smb.conf"

    for line in "${lines[@]}"; do
        echo "$line" | sudo tee -a "$smb_conf" > /dev/null
    done

    echo "Modified smb_conf"
    sleep 1
    sudo touch /.autorelabel
}

status-checker(){
    sudo ufw status && sleep 3
    sudo systemctl restart ssh && echo "restarted ssh" && sleep 1
    sudo service smbd status && sleep 3
    sudo systemctl restart smbd && echo "restarted Samba" && sleep 1
    sudo service ssh status && sleep 3
    echo "Reboot your server for changes to take effect."
}


CALUS(){
    getname
    updater
    app-fetcher
    firewall
    new_acct
    update_smbconf
    status-checker
}


CALUS