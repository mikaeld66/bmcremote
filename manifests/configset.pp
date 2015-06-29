#
define bmcremote::configset(
  $target,
  $type,
  $settings,
) {
  # Simplify looking up data with an index variable
#  $index = delete($name, 'bmcremote_configset_')
  $index = delete($name, "${target}")
 
  $order = $settings[$index]['order']
  $check = $settings[$index]['check']
  $set   = $settings[$index]['set']
  $exec  = $settings[$index]['exec']
 
  concat::fragment {"${name}_${order}":
    target  => $target,
    content => template("bmcremote/${type}.erb"),
    order   => $order,
  }
}

