
class keepalived::default {

  $source                        = 'git://github.com/coraltech/keepalived.git'
  $revision                      = 'coraltech'
  $service_ensure                = 'running'
  $dev_ensure                    = 'present'

  $firewall_ports                = []
  $sysctl_directives             = {}

  $global_definitions            = {}
  $virtual_servers               = []

  $vrrp_sync_groups              = []
  $vrrp_instances                = []
  $vrrp_scripts                  = []

  #---

  case $::operatingsystem {
    debian, ubuntu: {
      $repo                      = '/usr/local/lib/keepalived'
      $service                   = 'keepalived'

      $dev_packages              = []

      $build_options             = '--prefix=""'
      $build_package_init_script = '/etc/rc.d/init.d/keepalived'

      $init_script               = '/etc/init.d/keepalived'
      $run_level_script          = '/etc/rc3.d/S99keepalived'

      $config_dir                = '/etc/keepalived'
      $config_file               = 'keepalived.conf'
      $config_template           = 'keepalived/keepalived.conf.erb'

      $sysctl_config             = '/etc/sysctl.d/keepalived.conf'
      $sysctl_config_template    = 'keepalived/sysctl.conf.erb'
      $sysctl_reload_command     = 'sysctl -p'
    }
    default: {
      fail("The keepalived module is not currently supported on ${::operatingsystem}")
    }
  }
}
