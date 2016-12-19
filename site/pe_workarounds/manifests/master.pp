# vim: set expandtab:
# Workarounds for Puppet Enterprise
#
# @param console_systems The systems that are allowed to access the PE console
# @param client_nets The client systems that are allowed to connect to PE.
# @param enable_iptables Provide support for the SIMP IPTables stack
#
class pe_workarounds::master (
  $console_systems = ['127.0.0.1'],
  $client_nets     = defined('$::client_nets')  ? { true => $::client_nets,  default => hiera('client_nets', '127.0.0.1') },
  $enable_iptables = defined('$::use_iptables') ? { true => $::use_iptables, default => hiera('use_iptables', false) },
) {

  validate_bool($enable_iptables)

  if $enable_iptables {
    include '::iptables'

    iptables::add_tcp_stateful_listen { 'allow_pe_console':
      dports => ['443'],
    }

    iptables::add_tcp_stateful_listen { 'allow_pe_clients':
      dports => ['8140','61613', '8142'],
    }
  }

  pe_ini_setting { 'digest_algorithm':
    ensure  => present,
    setting => 'digest_algorithm',
    value   => 'sha256',
    section => 'main',
    path    => '/etc/puppetlabs/puppet/puppet.conf',
  }
}
