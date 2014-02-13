class puppet (
  $config = hiera_hash("${module_name}::config",undef)
) {
  include puppet::agent

  if $config != undef {
    create_resources('puppet::config',$config)
  }
}
