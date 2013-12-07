class puppet::agent ( $ensure        = hiera("${module_name}::agent::ensure"),
                      $server        = hiera("${module_name}::agent::server"),
                      $daemonize     = hiera("${module_name}::agent::daemonize",true),
                      $cronschedule  = hiera("${module_name}::agent::cronschedule", '*/30 * * * *')) {

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
    case $ensure {
      present: { $file_ensure = file }
      absent: { $file_ensure = absent }
      default: { fail('Only present and absent are valid ensure values in non-daemon mode!') }
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
      'Fedora': { $servicename = 'puppetagent.service' }
      default: { $servicename = 'puppet' }
    }

    service { $servicename:
      ensure => $ensure
    }
  }
}
