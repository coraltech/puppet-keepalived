
class keepalived::params inherits keepalived::default {

  $repo                      = module_param('repo')
  $source                    = module_param('source')
  $revision                  = module_param('revision')
  $service                   = module_param('service')
  $service_ensure            = module_param('service_ensure')

  $dev_packages              = module_array('dev_packages')
  $dev_ensure                = module_param('dev_ensure')

  $build_options             = module_param('build_options')
  $build_package_init_script = module_param('build_package_init_script')
  $init_script               = module_param('init_script')
  $run_level_script          = module_param('run_level_script')

  #---

  $firewall_ports            = module_array('firewall_ports')

  $config_dir                = module_param('config_dir')
  $config_file               = module_param('config_file')
  $config_template           = module_param('config_template')

  $sysctl_config             = module_param('sysctl_config')
  $sysctl_config_template    = module_param('sysctl_config_template')
  $sysctl_reload_command     = module_param('sysctl_reload_command')
  $sysctl_directives         = module_hash('sysctl_directives')

  $global_definitions        = module_hash('global_definitions')
  $virtual_servers           = module_array('virtual_servers')
  $vrrp_sync_groups          = module_array('vrrp_sync_groups')
  $vrrp_instances            = module_array('vrrp_instances')
  $vrrp_scripts              = module_array('vrrp_scripts')
}
