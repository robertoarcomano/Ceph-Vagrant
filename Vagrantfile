CEPH_USER = "ceph-admin"

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provision "shell" do |s|
    s.path = "script.sh"
    s.args = [CEPH_USER]
  end
  config.vm.provision "file", source: "id_rsa.pub", destination: "/home/vagrant/id_rsa.pub"
  config.vm.provision "shell" do |s|
    s.inline = "cat /home/vagrant/id_rsa.pub >> /home/" + CEPH_USER + "/.ssh/authorized_keys; chown " + CEPH_USER + " -R /home/" + CEPH_USER + "; rm /home/vagrant/id_rsa.pub"
    s.privileged = true
  end

  config.vm.define "ceph1" do |ceph1|
    ceph1.vm.hostname = "ceph1"
    ceph1.vm.network :private_network, ip: "192.168.10.2"
  end

  config.vm.define "ceph2" do |ceph2|
    ceph2.vm.hostname = "ceph2"
    ceph2.vm.network :private_network, ip: "192.168.10.3"
  end
end

# config.vm.provision "shell", inline: "echo Hello"