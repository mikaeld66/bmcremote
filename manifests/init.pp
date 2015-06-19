# == Class: bmcremote
#
# Class which ensure a desired management console setting
# - currently supports only (iD)RAC from Dell
#
# === Parameters
#
# The name format of the resource created should be:
# <ip address>/<resource to set>
#   Example: 10.10.10.10/bios.biosbootsettings.bootmode
#
# There is only one (required) parameter: setting
#   This  defines the desired setting of the named resource
#

class bmcremote (
  $package_names = $::bmcremote::params::package_names,
  $hostdata      = {},
) inherits bmcremote::params {

  # validate parameters here

  class { 'bmcremote::install': } ->
  class { 'bmcremote::config': } -> 
  Class["bmcremote"]

  $host_keys = keys($hostdata)

  bmcremote::host  { $host_keys:
    data => $hostdata,
  }
}
