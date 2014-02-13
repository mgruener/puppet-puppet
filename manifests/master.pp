class puppet::master (
  $ensure = running,
  $enable = true,
) {

  validate_bool($enable)

  package { 'puppet-server':
    ensure => present
  }

  case $::operatingsystem {
    'Fedora': { $servicename = 'puppetmaster.service'
                $serviceprovider = systemd
    }
    default: {  $servicename = 'puppetmaster'
                $serviceprovider = undef
    }
  }

  service { $servicename:
    ensure   => $ensure,
    enable   => $enable,
    provider => $serviceprovider,
  }
}
