#!/usr/bin/env bats
# Demo showing HA Cluster

# 0. Set SSH_PARAMS and SSH_CLIENT
SSH_PARAMS="-o StrictHostKeyChecking=no -i ./id_rsa"
SSH_CLIENT="ssh $SSH_PARAMS ceph-admin@cephclient"
TIMEOUT=120

GlobalOSD=$($SSH_CLIENT sudo ceph -s | grep osd | awk '{print $2}')
ActiveOSD=$($SSH_CLIENT sudo ceph -s | grep osd | awk '{print $4}')
@test "Global OSD = Active OSD" {
  [ "$GlobalOSD" -eq "$ActiveOSD" ]
}

@test "Disk /dev/rbd0 existence" {
  $SSH_CLIENT sudo fdisk -l /dev/rbd0
  [ "$?" -eq "0" ]
}

@test "Activities on disk /dev/rbd0" {
  $SSH_CLIENT sudo mkdir -p /media/rbd0
  $SSH_CLIENT sudo mkfs.ext4 /dev/rbd0
  $SSH_CLIENT sudo mount /dev/rbd0 /media/rbd0
  $SSH_CLIENT sudo rsync -av /bin /etc /media/rbd0/
  NUM_DIR=$($SSH_CLIENT sudo ls /media/rbd0/|grep -v lost|wc -l)
  $SSH_CLIENT sudo umount /media/rbd0
  [ "$NUM_DIR" -eq "2" ]
}

@test "Activities without ceph1" {
  # skip "Not working"
  vagrant suspend ceph1
  $SSH_CLIENT sudo mkdir -p /media/rbd0
  $SSH_CLIENT timeout $TIMEOUT sudo mkfs.ext4 /dev/rbd0
  $SSH_CLIENT timeout $TIMEOUT sudo mount /dev/rbd0 /media/rbd0
  $SSH_CLIENT sudo rsync -av /bin /etc /media/rbd0/
  NUM_DIR=$($SSH_CLIENT sudo ls /media/rbd0/|grep -v lost|wc -l)
  $SSH_CLIENT sudo umount /media/rbd0
  vagrant resume ceph1
  [ "$NUM_DIR" -eq "2" ]
}

@test "Activities without ceph2" {
  # skip "Not working"
  vagrant suspend ceph2
  $SSH_CLIENT sudo mkdir -p /media/rbd0
  $SSH_CLIENT timeout $TIMEOUT sudo mkfs.ext4 /dev/rbd0
  $SSH_CLIENT timeout $TIMEOUT sudo mount /dev/rbd0 /media/rbd0
  $SSH_CLIENT sudo rsync -av /bin /etc /media/rbd0/
  NUM_DIR=$($SSH_CLIENT sudo ls /media/rbd0/|grep -v lost|wc -l)
  $SSH_CLIENT sudo umount /media/rbd0
  vagrant resume ceph2
  [ "$NUM_DIR" -eq "2" ]
}

@test "Activities without ceph3" {
  # skip "Not working"
  vagrant suspend ceph3
  $SSH_CLIENT sudo mkdir -p /media/rbd0
  $SSH_CLIENT timeout $TIMEOUT sudo mkfs.ext4 /dev/rbd0
  $SSH_CLIENT timeout $TIMEOUT sudo mount /dev/rbd0 /media/rbd0
  $SSH_CLIENT sudo rsync -av /bin /etc /media/rbd0/
  NUM_DIR=$($SSH_CLIENT sudo ls /media/rbd0/|grep -v lost|wc -l)
  $SSH_CLIENT sudo umount /media/rbd0
  vagrant resume ceph3
  [ "$NUM_DIR" -eq "2" ]
}
