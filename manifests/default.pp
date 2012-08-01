
class keepalived::default {
  $keepalived_package_ensure  = 'present'
  $keepalived_service_ensure  = 'running'
  $sysctl_directives          = {}
  $global_definitions         = {}
  $virtual_servers            = []
  $vrrp_sync_groups           = []
  $vrrp_instances             = []
  $vrrp_scripts               = []
}
