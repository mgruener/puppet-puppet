class puppet::agent ( $ensure        = hiera("${module_name}::agent::ensure",running),
                      $enable        = hiera("${module_name}::agent::enable",true),
                      $server        = hiera("${module_name}::agent::server",$fqdn),
                      $daemonize     = hiera("${module_name}::agent::daemonize",true),
                      $cronschedule  = hiera("${module_name}::agent::cronschedule", '*/30 * * * *')) {

  validate_bool($enable,$daemonize)
  if !is_domain_name($server) { warning ("${server} is not a valid fqdn") }

  puppet::config { 'server':
    value   => $server,
    section => 'agent'
  }

  puppet::config { 'daemonize':
    value   => $daemonize,
    section => 'agent'
  }

  puppet::config { 'onetime':
    value   => !$daemonize,
    section => 'agent'
  }

  if !$daemonize {
    $file_ensure = $enable ? {
      true => file,
      false => absent
    }

    file { '/etc/cron.d/puppetagent':
      ensure  => $file_ensure,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => "${cronschedule} root /bin/puppet agent\n"
    }
  }
  else {
    case $::operatingsystem {
      'Fedora': { $servicename = 'puppetagent.service'
                  $serviceprovider = systemd
      }
      default: {  $servicename = 'puppet'
                  $serviceprovider = undef
      }
    }

    service { $servicename:
      ensure   => $ensure,
      enable   => $enable,
      provider => $serviceprovider,
    }
  }
}
