
class keepalived::params {

  include keepalived::default

  #-----------------------------------------------------------------------------
  # General configurations

  if $::hiera_ready {
    $keepalived_package_ensure  = hiera('keepalived_package_ensure', $keepalived::default::keepalived_package_ensure)
    $keepalived_service_ensure  = hiera('keepalived_service_ensure', $keepalived::default::keepalived_service_ensure)
    $sysctl_directives          = hiera_hash('keepalived_sysctl_directives', $keepalived::default::sysctl_directives)
    $global_definitions         = hiera_hash('keepalived_global_definitions', $keepalived::default::global_definitions)
    $virtual_servers            = hiera_array('keepalived_virtual_servers', $keepalived::default::virtual_servers)
    $vrrp_sync_groups           = hiera_array('keepalived_vrrp_sync_groups', $keepalived::default::vrrp_sync_groups)
    $vrrp_instances             = hiera_array('keepalived_vrrp_instances', $keepalived::default::vrrp_instances)
    $vrrp_scripts               = hiera_array('keepalived_vrrp_scripts', $keepalived::default::vrrp_scripts)
  }
  else {
    $keepalived_package_ensure  = $keepalived::default::keepalived_package_ensure
    $keepalived_service_ensure  = $keepalived::default::keepalived_service_ensure
    $sysctl_directives          = $keepalived::default::sysctl_directives
    $global_definitions         = $keepalived::default::global_definitions
    $virtual_servers            = $keepalived::default::virtual_servers
    $vrrp_sync_groups           = $keepalived::default::vrrp_sync_groups
    $vrrp_instances             = $keepalived::default::vrrp_instances
    $vrrp_scripts               = $keepalived::default::vrrp_scripts
  }

  #-----------------------------------------------------------------------------
  # Operating system specific configurations

  case $::operatingsystem {
    debian, ubuntu: {
      $os_keepalived_package = 'keepalived'
      $os_keepalived_service = 'keepalived'

      $os_config                 = '/etc/keepalived/keepalived.conf'
      $os_config_template        = 'keepalived/keepalived.conf.erb'

      $os_sysctl_config          = '/etc/sysctl.d/keepalived.conf'
      $os_sysctl_config_template = 'keepalived/sysctl.conf.erb'

      $os_sysctl_reload_command  = 'sysctl -p'
    }
    default: {
      fail("The keepalived module is not currently supported on ${::operatingsystem}")
    }
  }
}
