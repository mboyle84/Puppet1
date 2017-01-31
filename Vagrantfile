
VAGRANTFILE_API_VERSION = "2"
# Require the reboot plugin. this is a note for testing
require './vagrant-provision-reboot-plugin'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
 
config.vm.provider "virtualbox" do |vb|
  
        vb.gui = true
        vb.customize ["modifyvm", :id, "--memory", "1024"]
        vb.cpus = 1
        #Change the mac from default to not interrupt communication on network.The mac might already exist, same thing for hostname below.
        vb.customize ["modifyvm", :id, "--macaddress1", "08002789D579" ]
        
        
end

#defines Machine to use for Base
config.vm.box = "kensykora/windows_2012_r2_standard" # the name of the box, completed for you by vagrant init

#general network and machine settings
config.vm.guest = :windows
#modify the host name and above mac from defaults.Otherwise, collitions could occur on the network
config.vm.hostname = "S3x64Test"

	

config.vm.communicator = "winrm"
#restart due to hostname change above reboot pluing above actualyl works with this command
config.vm.provision :windows_reboot

# forward RDP and WINRS ports
config.vm.network :forwarded_port, guest: 3389, host: 3377, id: "rdp", auto_correct: false
#config.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
config.winrm.max_tries = 10
  
# Ensure that all networks are set to private
config.windows.set_work_network = true

# chocolatey:
config.vm.provision :shell, path: "install-chocolatey.ps1"
config.vm.provision :shell, inline: '[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Chocolatey\bin", "Machine")'
  # Puppet:
config.vm.provision :shell, path: "install-puppet.ps1"
config.vm.provision :shell, path: "install-puppet-modules.ps1"
#added 5m delay as on Windows host machines puppet sometimes take alitle longer to install
config.vm.provision "shell", inline: "Start-Sleep -s 300"
config.vm.provision :windows_reboot
config.vm.provision "puppet"
	config.vm.provision :puppet do |puppet|
#	puppet.manifests_path = "./manifests"
#	puppet.module_path = "modules"
#	puppet.manifest_file = "default.pp"
#	puppet.options = "--verbose --debug"

end


# main script to setup Trade Show image

	#inline commd to add delay of 15m or 30, no longer require for SQL or other software, as i look for process finishing, more example now.
	#config.vm.provision "shell", inline: "Start-Sleep -s 1800"

end
