#!/bin/bash
# 0. Destroy existence vagrant VMs
LOG=./log.txt
SSH_PARAMS="-o StrictHostKeyChecking=no -i ./id_rsa"

vagrant destroy -f
rm $LOG
ssh-keygen -f ~/.ssh/known_hosts -R "ceph1"
ssh-keygen -f ~/.ssh/known_hosts -R "ceph2"
ssh-keygen -f ~/.ssh/known_hosts -R "ceph3"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.2"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.3"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.4"

# 1. Create log
date > $LOG

# 2. Create ssh key pair
rm -f ./id_rsa ./id_rsa.pub
ssh-keygen -t rsa -N "" -f ./id_rsa

# 3. Start Vagrant VMs
vagrant up | tee -a $LOG

# 4. SSH dummy connections to create entries on known_hosts
ssh $SSH_PARAMS ceph-admin@ceph1 "ssh -o StrictHostKeyChecking=no ceph1 ls; \
                                  ssh -o StrictHostKeyChecking=no ceph2 ls; \
                                  ssh -o StrictHostKeyChecking=no ceph3 ls"

# 5. Launch commands
ssh $SSH_PARAMS ceph-admin@ceph1 ceph-deploy new ceph1

ssh $SSH_PARAMS ceph-admin@ceph1 ceph-deploy install ceph1 ceph2 ceph3

ssh $SSH_PARAMS ceph-admin@ceph1 ceph-deploy mon create-initial

ssh $SSH_PARAMS ceph-admin@ceph1 ceph-deploy admin ceph1 ceph2 ceph3

ssh $SSH_PARAMS ceph-admin@ceph1 ceph-deploy mgr create ceph1

# 10. End date
date >> $LOG
