#!/bin/bash
env TZ=Europe/Dublin
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
apt-get update && apt-get install -y openssh-server vim supervisor ceph-deploy iputils-ping ntp sudo systemd
mkdir /var/run/sshd

sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#SyslogFacility AUTH/SyslogFacility AUTH/' /etc/ssh/sshd_config
sed -i 's/#LogLevel INFO/LogLevel INFO/' /etc/ssh/sshd_config

sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
echo "export VISIBLE=now" >> /etc/profile

USER=$1
useradd -ms /bin/bash $USER
mkdir -p /home/$USER/.ssh
chmod 700 /home/$USER/.ssh
# ssh-keygen -f /home/$USER/.ssh/id_rsa -N ""
# cp /home/$USER/.ssh/id_rsa.pub /home/$USER/.ssh/authorized_keys

# Add sudo rules
echo "$USER ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USER
chmod 0440 /etc/sudoers.d/$USER
