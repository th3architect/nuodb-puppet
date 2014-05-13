node default {
  class { "java": before => Class['nuodb'] }

  class { "nuodb": require => Class['java'] }
}