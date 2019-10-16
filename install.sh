#!/bin/bash
# 1. Destroy existence vagrant VMs
vagrant destroy -f

# 2. Create ssh key pair
rm -f ./id_rsa ./id_rsa.pub
ssh-keygen -t rsa -N "" -f ./id_rsa

# 3. Start Vagrant VMs
vagrant up
