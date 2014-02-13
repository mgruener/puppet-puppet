define puppet::config (
  $ensure = present,
  $section = 'main',
  $value = undef,
  $configfile = '/etc/puppet/puppet.conf',
) {

  case $ensure {
    present: {
      if $value == undef {
        fail("You have to provide a value for ${title}")
      }
      if $section == undef {
        fail("You have to provide a section for ${title}")
      }
      $action = 'set'
    }
    absent: {
      $action = 'rm'
    }
    default: { fail('Ensure can only be present or absent') }
  }

  if is_array($value) {
    $flatvalue = join($value,',')
  }
  else {
    $flatvalue = $value
  }

  augeas { "puppet-conf-${title}":
    context => "/files${configfile}/${section}",
    incl    => $configfile,
    lens    => 'Puppet.lns',
    changes => "${action} ${title} '${flatvalue}'"
  }
}
