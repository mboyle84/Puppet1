$pfx = new-object System.Security.Cryptography.X509Certificates.X509Certificate2 
$certPath =  "C:\vagrant\GeoTrust_Global_CA.pfx"
#$pfxPass = read-host "Password" -assecurestring
$pfx.import($certPath,$pfxPass,"Exportable,PersistKeySet") 
$store = new-object System.Security.Cryptography.X509Certificates.X509Store(
    [System.Security.Cryptography.X509Certificates.StoreName]::Root,
    "localmachine"
)
$store.open("MaxAllowed") 
$store.add($pfx) 
$store.close()
Write-Host "Certificate added from GeoTrust to Trust Root to allow puppet forge SSL certificate on clean machine"
& 'C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat' module install rismoney-chocolatey
Write-Host "Install Puppet IIS module manually"
& 'C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat' module install puppet-iis
Write-Host "Install Puppet dsc module manually"
& 'C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat' module install puppetlabs-dsc
Write-Host "install xwebadministration powershell module"
Install-Module -Name xWebAdministration -Force

#& 'C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat' module install puppet-iis --version 2.0.2
#Write-Host "Install Puppet dsc module manually"
#& 'C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat' module install puppetlabs-dsc --version 1.2.0
