#!/usr/bin/env bats
# Demo showing HA Cluster

# 0. Set SSH_PARAMS and SSH_CLIENT
SSH_PARAMS="-o StrictHostKeyChecking=no -i ./id_rsa"
SSH_CLIENT="timeout 5s ssh $SSH_PARAMS ceph-admin@cephclient "

GlobalOSD=$($SSH_CLIENT sudo ceph -s | grep osd | awk '{print $2}')
ActiveOSD=$($SSH_CLIENT sudo ceph -s | grep osd | awk '{print $4}')
@test "Global OSD = Active OSD" {
  [ "$GlobalOSD" -eq "$ActiveOSD" ]
}

@test "Disk /dev/rbd0 working" {
  $SSH_CLIENT sudo fdisk -l /dev/rbd0
  [ "$?" -eq "0" ]
}

# vagrant suspend ceph1
