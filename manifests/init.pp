# Class: keepalived
#
#   This module manages the Keepalived service.
#
#   Adrian Webb <adrian.webb@coraltech.net>
#   2012-07-31
#
#   Tested platforms:
#    - Ubuntu 12.04
#
# Parameters: (see <example/params.json> for Hiera configurations)
#
# Actions:
#
#  Installs, configures, and manages the Keepalived service.
#
# Requires:
#
# Sample Usage:
#
#   class { 'keepalived':
#
#   }
#
# [Remember: No empty lines between comments and class definition]
class keepalived (

  $repo                      = $keepalived::params::repo,
  $source                    = $keepalived::params::source,
  $revision                  = $keepalived::params::revision,
  $service                   = $keepalived::params::service,
  $service_ensure            = $keepalived::params::service_ensure,
  $dev_packages              = $keepalived::params::dev_packages,
  $dev_ensure                = $keepalived::params::dev_ensure,
  $build_options             = $keepalived::params::build_options,
  $firewall_ports            = $keepalived::params::firewall_ports,
  $config_dir                = $keepalived::params::config_dir,
  $config_file               = $keepalived::params::config_file,
  $config_template           = $keepalived::params::config_template,
  $sysctl_config             = $keepalived::params::sysctl_config,
  $sysctl_directives         = $keepalived::params::sysctl_directives,
  $sysctl_config_template    = $keepalived::params::sysctl_config_template,
  $sysctl_reload_command     = $keepalived::params::sysctl_reload_command,
  $build_package_init_script = $keepalived::params::build_package_init_script,
  $init_script               = $keepalived::params::init_script,
  $run_level_script          = $keepalived::params::run_level_script,
  $global_definitions        = $keepalived::params::global_definitions,
  $virtual_servers           = $keepalived::params::virtual_servers,
  $vrrp_sync_groups          = $keepalived::params::vrrp_sync_groups,
  $vrrp_instances            = $keepalived::params::vrrp_instances,
  $vrrp_scripts              = $keepalived::params::vrrp_scripts,

) inherits keepalived::params {

  include global

  #-----------------------------------------------------------------------------
  # Installation

  global::make { $repo:
    source       => $source,
    revision     => $revision,
    dev_packages => $dev_packages,
    dev_ensure   => $dev_ensure,
    options      => $build_options,
  }

  #-----------------------------------------------------------------------------
  # Configuration

  if ! empty($firewall_ports) {
    keepalived::rule { $firewall_ports: }
  }

  #---

  file { 'keepalived-config-dir':
    path    => $config_dir,
    ensure  => directory,
    require => Global::Make[$repo],
  }

  file { 'keepalived-config':
    path    => "${config_dir}/${config_file}",
    content => template($config_template),
    require => File['keepalived-config-dir'],
    notify  => Service['keepalived'],
  }

  file { 'keepalived-sysctl-config':
    path    => $sysctl_config,
    content => template($sysctl_config_template),
    require => File['keepalived-config'],
    notify  => Exec['keepalived-sysctl-reload'],
  }

  exec { 'keepalived-sysctl-reload':
    command     => $sysctl_reload_command,
    path        => [ '/sbin', '/usr/sbin', '/usr/local/sbin' ],
    refreshonly => true,
    require     => File['keepalived-sysctl-config'],
    notify      => Service['keepalived'],
  }

  if $init_script != $build_package_init_script {
    file { 'keepalived-service':
      ensure    => link,
      path      => $init_script,
      source    => $build_package_init_script,
      subscribe => Global::Make[$repo],
      notify    => Service['keepalived'],
    }
  }

  file { "keepalived-run-level":
    ensure    => link,
    path      => $run_level_script,
    source    => $build_package_init_script,
    subscribe => Global::Make[$repo],
  }

  #-----------------------------------------------------------------------------
  # Services

  if ! ( empty($virtual_servers) or empty($vrrp_instances) ) {
    $service_ensure_real = $service_ensure
  }
  else {
    $service_ensure_real = 'stopped'
  }

  service { 'keepalived':
    name    => $service,
    ensure  => $service_ensure_real,
    require => [ Global::Make[$repo], File['keepalived-sysctl-config'] ],
  }
}

#-------------------------------------------------------------------------------

define keepalived::rule($port) {

  $rule_description = "150 INPUT Allow Keepalive connections: $port"

  #-----------------------------------------------------------------------------

  if $port and ! defined(Firewall[$rule_description]) {
    firewall { $rule_description:
      action => accept,
      chain  => 'INPUT',
      state  => 'NEW',
      proto  => 'tcp',
      dport  => $port,
    }
  }
}
