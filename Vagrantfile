CEPH_USER = "ceph-admin"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provision "shell" do |s|
    s.path = "script.sh"
    s.args = [CEPH_USER]
  end
  config.vm.provision "file", source: "id_rsa.pub", destination: "/home/vagrant/id_rsa.pub"
  config.vm.provision "file", source: "id_rsa", destination: "/home/vagrant/id_rsa"
  config.vm.provision "shell" do |s|
    s.inline = "mv /home/vagrant/id_rsa.pub /home/" + CEPH_USER + "/.ssh/id_rsa.pub; cp /home/" + CEPH_USER + "/.ssh/id_rsa.pub /home/" + CEPH_USER + "/.ssh/authorized_keys; \
                mv /home/vagrant/id_rsa /home/" + CEPH_USER + "/.ssh/id_rsa; \
                chown " + CEPH_USER + " -R /home/" + CEPH_USER + ""
    s.privileged = true
  end
  config.vm.provision "file", source: "hosts", destination: "/home/vagrant/hosts"
  config.vm.provision "shell" do |s|
    s.inline = "sudo cat /home/vagrant/hosts >> /etc/hosts; rm /home/vagrant/hosts"
    s.privileged = true
  end

  config.vm.define "cephclient" do |cephclient|
    cephclient.vm.hostname = "cephclient"
    cephclient.vm.network :private_network, ip: "192.168.10.2"
  end

  config.vm.define "cephadmin" do |cephadmin|
    cephadmin.vm.hostname = "cephadmin"
    cephadmin.vm.network :private_network, ip: "192.168.10.3"
  end

  config.vm.define "ceph1" do |ceph1|
    ceph1.vm.hostname = "ceph1"
    ceph1.vm.network :private_network, ip: "192.168.10.4"
  end

  config.vm.define "ceph2" do |ceph2|
    ceph2.vm.hostname = "ceph2"
    ceph2.vm.network :private_network, ip: "192.168.10.5"
  end

  config.vm.define "ceph3" do |ceph3|
    ceph3.vm.hostname = "ceph3"
    ceph3.vm.network :private_network, ip: "192.168.10.6"
  end
end
