class puppet::params {
      case $::operatingsystem {
      'Fedora': { $serviceprovider = systemd
                  $agent_servicename = 'puppet.service'
                  $agent_serviceprovider = $serviceprovider
                  $master_servicename = 'puppetmaster.service'
                  $master_serviceprovider = $serviceprovider
      }
      default: {$serviceprovider = undef
                $agent_servicename = 'puppet'
                $agent_serviceprovider = $serviceprovider
                $master_servicename = 'puppetmaster'
                $master_serviceprovider = $serviceprovider
      }
    }

}
