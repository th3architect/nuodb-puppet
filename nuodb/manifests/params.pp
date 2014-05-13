class nuodb::params{
  
  $config_dir = "/opt/nuodb/etc"
  
  if $::osfamily == 'RedHat' or $::operatingsystem == 'amazon' {
    $package_source = "http://download.nuohub.org/nuodb-2.0.3.linux.x64.rpm"
    $package_provider = "rpm"
  } elsif $::osfamily == 'Debian' {
    $package_source = "http://download.nuohub.org/nuodb-2.0.3.linux.x64.deb"
    $package_provider = "apt"
  } else {
    fail("Class['nuodb::params']: Unsupported osfamily: ${::osfamily}")
  }
}