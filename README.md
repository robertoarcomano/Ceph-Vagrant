# Ceph-Vagrant
Example to create Ceph Environment using Vagrant on Virtualbox

## 1. Execute install.sh
#### 1.1. Destroy existence vagrant VMs
```
vagrant destroy -f
```

#### 1.2. Create ssh key pair
```
rm -f ./id_rsa ./id_rsa.pub
ssh-keygen -t rsa -N "" -f ./id_rsa
```

#### 1.3. Start Vagrant VMs
```
vagrant up
```
