# vim: set expandtab:
# Set the global Exec path to something reasonable
Exec {
  path => [
    '/usr/local/bin',
    '/usr/local/sbin',
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin',
  ],
}

$compliance_profile = 'nist_800_53_rev4'

unless getvar('::hostgroup') {
  $hostgroup = 'default'
}

$hiera_classes          = lookup('classes',          Array[String], 'unique', [])
$hiera_class_exclusions = lookup('class_exclusions', Array[String], 'unique', [])
$hiera_include_classes  = $hiera_classes - $hiera_class_exclusions

node default {

}
node agent.test {
  include $hiera_include_classes
}
node mom2.test {
  include $hiera_include_classes
}
