class puppet::agent (
  $ensure       = running,
  $enable       = true,
  $server       = $::fqdn,
  $daemonize    = true,
  $cronschedule = '*/30 * * * *',
  $agent_servicename = $::puppet::params::agent_servicename,
  $agent_serviceprovider = $::puppet::params::agent_serviceprovider,
) inherits puppet::params {

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
    service { $agent_servicename:
      ensure   => $ensure,
      enable   => $enable,
      provider => $agent_serviceprovider,
    }
  }
}
