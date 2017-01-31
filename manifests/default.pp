reboot { 'dsc_reboot':
  when    => pending,
  timeout => 15,
}
package { 'dotnet4.5.2':
  ensure   => latest,
  provider => 'chocolatey',
  notify   => Reboot['dsc_reboot'],
}->
package { 'powershell':
  ensure          => latest,
  provider        => 'chocolatey',
  install_options => ['-pre'],
  notify          => Reboot['dsc_reboot'],
}->
dsc_windowsfeature{'iis':
  dsc_ensure => 'Present',
  dsc_name   => 'Web-Server',
}->
dsc_windowsfeature{'iisscriptingtools':
  dsc_ensure => 'Present',
  dsc_name   => 'Web-Scripting-Tools',
}->
dsc_windowsfeature{'aspnet45':
  dsc_ensure => 'Present',
  dsc_name   => 'Web-Asp-Net45',
}->
dsc_xwebsite{'defaultsite':
  dsc_ensure       => 'Present',
  dsc_name         => 'Default Web Site',
  dsc_state        => 'Stopped',
  dsc_physicalpath => 'C:\\inetpub\\wwwroot',
}->
dsc_file{'websitefolder':
  dsc_ensure          => 'present',
  dsc_sourcepath      => 'c:\\vagrant\\website_code',
  dsc_destinationpath => 'c:\\inetpub\\foo',
  dsc_recurse         => true,
  dsc_type            => 'Directory',
}->
dsc_xwebapppool{'newwebapppool':
  dsc_name                      => 'PuppetCodezAppPool',
  dsc_ensure                    => 'Present',
  dsc_managedruntimeversion     => 'v4.0',
  dsc_logeventonrecycle         => 'Memory',
  dsc_restartmemorylimit        => '1000',
  dsc_restartprivatememorylimit => '1000',
  dsc_identitytype              => 'ApplicationPoolIdentity',
  dsc_state                     => 'Started',
}->
dsc_xwebsite{'newwebsite':
  dsc_ensure          => 'Present',
  dsc_name            => 'PuppetCodez',
  dsc_state           => 'Started',
  dsc_physicalpath    => 'c:\\inetpub\\foo',
  dsc_applicationpool => 'PuppetCodezAppPool',
  dsc_bindinginfo     => [{
    protocol => 'HTTP',
    port     => 80,
  }]
}