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

  $repo                   = $keepalived::params::os_keepalived_repo,
  $source                 = $keepalived::params::keepalived_source,
  $revision               = $keepalived::params::keepalived_revision,
  $service                = $keepalived::params::os_keepalived_service,
  $service_ensure         = $keepalived::params::keepalived_service_ensure,
  $firewall_ports         = $keepalived::params::firewall_ports,
  $config                 = $keepalived::params::os_config,
  $sysctl_config          = $keepalived::params::os_sysctl_config,
  $sysctl_directives      = $keepalived::params::sysctl_directives,
  $sysctl_config_template = $keepalived::params::os_sysctl_config_template,
  $sysctl_reload_command  = $keepalived::params::os_sysctl_reload_command,
  $global_definitions     = $keepalived::params::global_definitions,
  $virtual_servers        = $keepalived::params::virtual_servers,
  $vrrp_sync_groups       = $keepalived::params::vrrp_sync_groups,
  $vrrp_instances         = $keepalived::params::vrrp_instances,
  $vrrp_scripts           = $keepalived::params::vrrp_scripts,
  $config_template        = $keepalived::params::os_config_template,

) inherits keepalived::params {

  include global

  #-----------------------------------------------------------------------------
  # Installation

  global::build { $repo:
    source   => $source,
    revision => $revision,
  }

  #-----------------------------------------------------------------------------
  # Configuration

  if ! empty($firewall_ports) {
    keepalived::rule { $firewall_ports: }
  }

  #---

  file { 'keepalived-config':
    path    => $config,
    content => template($config_template),
    require => Package['keepalived'],
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
    refreshonly => true,
    require     => File['keepalived-sysctl-config'],
    notify      => Service['keepalived'],
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
    require => Package['keepalived'],
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
