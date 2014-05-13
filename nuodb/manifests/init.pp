class nuodb (
  $altAddr     = "",
  $autoconsole_logfile       = "var/log/restsvc.log",
  $autoconsole_port          = 8888,
  $autoconsole_admin_port    = 8889,
  $automationTemplate        = "Minimally Redundant",
  $balancer    = "RegionBalancer",
  $brokers     = [],
  $config_dir  = $::nuodb::config_dir,
  $domain_name = "domain",
  $domain_password           = "bird",
  $enableAutomation          = true,
  $enableAutomationBootstrap = true,
  $is_broker   = true,
  $license     = "",
  $log_level    = "INFO",
  $package_provider          = $::nuodb::params::package_provider,
  $package_source            = $::nuodb::params::package_source,
  $port        = 48004,
  $portRange   = 48005,
  $region      = "default",
  $start_services            = true,
  $webconsole_port           = 8080
  ) inherits ::nuodb::params {
  
  
  $package = inline_template('<%= File.basename(@package_source) %>')
  $package_destination = "/tmp/${package}"

  if $start_services {
    $service_state = "running"
  } else {
    $service_state = "stopped"
  }

  wget::fetch { "Download NuoDB install package":
    source      => $package_source,
    destination => $package_destination,
    timeout     => 0,
    verbose     => false
  }

  package { "nuodb":
    ensure  => installed,
    require => Wget::Fetch['Download NuoDB install package'],
    provider => $package_provider,
    source  => $package_source
  }

  file { "${config_dir}/default.properties":
    ensure  => "file",
    content => template("nuodb/etc/default.properties"),
    owner   => "nuodb",
    group   => "nuodb",
    mode    => "0644",
    notify  => Service['nuoagent'],
    require => Package["nuodb"],
    before  => Service['nuoagent']
  }

  file { "${config_dir}/nuodb.config":
    ensure  => "file",
    content => template("nuodb/etc/nuodb.config"),
    owner   => "nuodb",
    group   => "nuodb",
    mode    => "0644",
    notify  => Service['nuoagent'],
    require => Package["nuodb"],
    before  => Service['nuoagent']
  }

  if $license != "" {
    file { "${config_dir}/license.file":
      ensure  => "file",
      content => $license,
      owner   => "nuodb",
      group   => "nuodb",
      mode    => "0644",
      notify  => Service['nuoagent'],
      require => Package["nuodb"],
      before  => Service['nuoagent']
    }
  }

  service { "nuoagent":
    ensure    => $service_state,
    enable    => $start_services,
    hasstatus => true,
    require   => Package["nuodb"]
  }

  if $is_broker {
    file { "${config_dir}/webapp.properties":
      ensure  => "file",
      content => template("nuodb/etc/webapp.properties"),
      owner   => "nuodb",
      group   => "nuodb",
      mode    => "0644",
      notify  => Service['nuowebconsole'],
      require => Package["nuodb"],
      before  => Service['nuowebconsole']
    }

    file { "${config_dir}/nuodb-rest-api.yml":
      ensure  => "file",
      content => template("nuodb/etc/nuodb-rest-api.yml"),
      owner   => "nuodb",
      group   => "nuodb",
      mode    => "0644",
      notify  => Service['nuoautoconsole'],
      require => Package["nuodb"],
      before  => Service['nuoautoconsole']
    }

    service { "nuowebconsole":
      ensure    => $service_state,
      enable    => $start_services,
      hasstatus => true,
      require   => Service['nuoagent']
    }

    service { "nuoautoconsole":
      ensure    => $service_state,
      enable    => $start_services,
      hasstatus => true,
      require   => Service['nuoagent']
    }
  } else {
    file { "${config_dir}/webapp.properties":
      ensure  => "file",
      content => template("nuodb/etc/webapp.properties"),
      owner   => "nuodb",
      group   => "nuodb",
      mode    => "0644",
      require => Package["nuodb"]
    }

    file { "${config_dir}/nuodb-rest-api.yml":
      ensure  => "file",
      content => template("nuodb/etc/nuodb-rest-api.yml"),
      owner   => "nuodb",
      group   => "nuodb",
      mode    => "0644",
      require => Package["nuodb"]
    }
  }
}