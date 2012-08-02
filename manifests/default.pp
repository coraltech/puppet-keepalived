
class keepalived::default {
  $keepalived_source           = 'git://github.com/coraltech/keepalived.git'
  $keepalived_revision         = 'master'
  $keepalived_service_ensure   = 'running'
  $firewall_ports              = []
  $sysctl_directives           = {}
  $global_definitions          = {}
  $virtual_servers             = []
  $vrrp_sync_groups            = []
  $vrrp_instances              = []
  $vrrp_scripts                = []
}
