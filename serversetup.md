## Commands for setting up the new ubuntu server

>These instructions in the CLI on Ubuntu
- check for updates (sudo apt update && sudo apt upgrade -y)
- sudo apt install cifs-utils
- sudo apt-get install nano
- sudo apt install samba
- sudo apt-get install ufw

- sudo ufw allow 22
- sudo ufw allow 139/tcp
- sudo ufw allow 445/tcp
- sudo ufw status

- sudo systemctl restart ssh
- sudo service ssh status

- sudo adduser username (make new user acct)
- sudo smbpasswd -a username (use system name)
- sudo smbpasswd -e username (enable user)

- sudo nano /etc/samba/smb.conf
    - add:
       >[shared]
       >path = /home/username
       >writable = yes
       >guest ok = no
       >read only = no
       >create mask = 0777
       >directory mask = 0777
       >server signing = mandatory
       >client signing = mandatory
       >passdb backend = smbpasswd


- sudo systemctl restart smbd

- sudo touch /.autorelabel
- sudo reboot
