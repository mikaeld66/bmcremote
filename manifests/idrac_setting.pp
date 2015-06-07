
define bmcremote::idrac_setting (
  $setting = '',
) {

  $host_object  = split($name, '/')
  $host         = $host_object[0]
  $object       = $host_object[1]

  exec { $name:
    command => "ensure_idrac_settings.sh $bmcremote::params::lockfile $host $object $setting",
    path    => "/bin:/usr/local/sbin:/opt/dell/srvadmin/sbin",
    creates => "$bmcremote::params::lockfile",
    unless  => "/bin/ls $bmcremote::params::lockfile",
  }
}
