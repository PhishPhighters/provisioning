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
    echo ""
    sleep 5
    echo "Okay, setting you up with $username"
    echo ""
    echo ""
}

updater(){
    sudo apt update && sudo apt upgrade -y && echo "###### Upgraded system"
    echo ""
    sleep 2
}

app-fetcher(){
    echo ""
    echo ""
    sudo apt install cifs-utils -y && echo "###### Installed CIFS"
    echo ""
    sleep 2

    echo ""
    echo ""
    sudo apt-get install nano -y && echo "###### Installed nano"
    echo ""
    sleep 2

    echo ""
    echo ""
    sudo apt install samba -y && echo "###### Installed samba"
    echo ""
    sleep 2

    echo ""
    echo ""
    sudo apt-get install ufw -y && echo "###### Installed ufw"
    echo ""
    sleep 2
}

firewall(){
    echo ""
    echo ""
    sudo ufw allow 22 && echo "###### Allowed SSH"
    echo ""
    sleep 2

    echo ""
    echo ""
    sudo ufw allow 139/tcp && sudo ufw allow 445/tcp && echo "###### Allowed TCP fileshare 139/445"
    echo ""
    sleep 2
}

new_acct(){
    echo ""
    echo ""
    sudo adduser $username && echo "###### Created user on Ubuntu with username $username"
    echo ""
    sleep 2

    echo ""
    echo ""
    sudo smbpasswd -a $username && echo "###### Added $username to Samba"
    echo ""
    sleep 2

    echo ""
    echo ""
    sudo smbpasswd -e $username && echo "###### Enabled $username on Samba"
    echo ""
    sleep 2
}

update_smbconf(){
    lines=("[shared]" "path = /home/$username" "writable = yes" "guest ok = no" "read only = no" "create mask = 0777" "directory mask = 0777"
        "server signing = mandatory" "client signing = mandatory" "passdb backend = smbpasswd")

    smb_conf="/etc/samba/smb.conf"

    for line in "${lines[@]}"; do
        echo "$line" | sudo tee -a "$smb_conf" > /dev/null
    done

    echo ""
    echo ""
    echo "###### Modified smb_conf"
    sleep 3
    echo ""

    sudo touch /.autorelabel
}

status-checker(){
    echo ""
    echo ""
    sudo ufw status && sleep 3
    echo ""
    echo ""
    sudo systemctl restart ssh && echo "###### restarted ssh" && sleep 1
    echo ""
    echo ""
    sudo service smbd status && sleep 3
    echo ""
    echo ""
    sudo systemctl restart smbd && echo "###### restarted Samba" && sleep 1
    echo ""
    echo ""
    sudo service ssh status && sleep 3
    echo ""
    echo ""
    echo "###### Reboot your server for changes to take effect."
    echo ""
    echo ""
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