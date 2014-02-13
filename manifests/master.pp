class puppet::master (
  $ensure = running,
  $enable = true,
  $master_servicename = $::puppet::params::master_servicename,
  $master_serviceprovider = $::puppet::params::master_serviceprovider,
) inherits puppet::params {

  validate_bool($enable)

  package { 'puppet-server':
    ensure => present
  }

  service { $master_servicename:
    ensure   => $ensure,
    enable   => $enable,
    provider => $master_serviceprovider,
  }
}
