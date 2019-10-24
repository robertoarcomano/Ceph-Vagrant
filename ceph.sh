#!/bin/bash
# 0. Destroy existence vagrant VMs
vagrant destroy -f

# 1. Remove old known_hosts entries
ssh-keygen -f ~/.ssh/known_hosts -R "cephclient"
ssh-keygen -f ~/.ssh/known_hosts -R "cephadmin"
ssh-keygen -f ~/.ssh/known_hosts -R "ceph1"
ssh-keygen -f ~/.ssh/known_hosts -R "ceph2"
ssh-keygen -f ~/.ssh/known_hosts -R "ceph3"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.2"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.3"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.4"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.5"
ssh-keygen -f ~/.ssh/known_hosts -R "192.168.10.6"

# 2. Create ssh key pair and export SSH parameters
rm -f ./id_rsa ./id_rsa.pub
ssh-keygen -t rsa -N "" -f ./id_rsa
SSH_PARAMS="-o StrictHostKeyChecking=no -i ./id_rsa"

# 3. Start Vagrant VMs
vagrant up

# 4. SSH dummy connections to create entries on known_hosts
ssh $SSH_PARAMS ceph-admin@cephadmin "ssh -o StrictHostKeyChecking=no cephclient ls; \
                                      ssh -o StrictHostKeyChecking=no cephadmin ls; \
                                      ssh -o StrictHostKeyChecking=no ceph1 ls; \
                                      ssh -o StrictHostKeyChecking=no ceph2 ls; \
                                      ssh -o StrictHostKeyChecking=no ceph3 ls"

# 5. Launch ceph commands
# 5.1. Create configuration
ssh $SSH_PARAMS ceph-admin@cephadmin ceph-deploy new ceph1 ceph2 ceph3
# 5.2. Install ceph software
ssh $SSH_PARAMS ceph-admin@cephadmin ceph-deploy install cephclient cephadmin ceph1 ceph2 ceph3
# 5.3. Start Monitors
ssh $SSH_PARAMS ceph-admin@cephadmin ceph-deploy mon create-initial
# 5.4. Copy ceph keys
ssh $SSH_PARAMS ceph-admin@cephadmin ceph-deploy admin cephclient cephadmin ceph1 ceph2 ceph3
# 5.5. Create managers
ssh $SSH_PARAMS ceph-admin@cephadmin ceph-deploy mgr create ceph1 ceph2 ceph3

# 6. Create 3 OSDs, one for each server
ssh $SSH_PARAMS ceph-admin@cephadmin ceph-deploy osd create --data /dev/vg00/lvol0 ceph1
ssh $SSH_PARAMS ceph-admin@cephadmin ceph-deploy osd create --data /dev/vg00/lvol0 ceph2
ssh $SSH_PARAMS ceph-admin@cephadmin ceph-deploy osd create --data /dev/vg00/lvol0 ceph3

# 7. Create a pool and init it
ssh $SSH_PARAMS ceph-admin@cephadmin sudo ceph osd pool create rbd 30
ssh $SSH_PARAMS ceph-admin@cephadmin sudo rbd pool init rbd

# 8. Create the storage
ssh $SSH_PARAMS ceph-admin@cephclient sudo rbd create storage0 --size 100M --pool rbd --image-feature layering

# 9. Map the storage into the client
ssh $SSH_PARAMS ceph-admin@cephclient sudo rbd map storage0 --name client.admin

# 10. Use ceph disk
ssh $SSH_PARAMS ceph-admin@cephclient "sudo mkdir /media/rbd0; \
                                       sudo mkfs.ext4 /dev/rbd0; \
                                       sudo mount /dev/rbd0 /media/rbd0; \
                                       sudo rsync -av /bin /etc /media/rbd0/; \
                                       sudo ls -al /media/rbd0"
