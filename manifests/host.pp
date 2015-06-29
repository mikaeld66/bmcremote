define bmcremote::host(
  $data = {}
) {

  if is_hash($data[$name]) {
    $index = merge($bmcremote::params::hostdata, $data[$name])
  } else {
    $index = $bmcremote::params::hostdata
  }

  # some local variables to make it easier to handle the data
  $user     = $index['user']
  $pass     = $index['pass']
  $ip       = $index['ip']
  $type     = $index['type']
  $settings = $index['settings']

  case $type {
    'idrac8': {
      # device specific values if needed
    }
    default: {
      fail("bmc device type ${type} not set or not supported")
    }   
  }
 
  concat { "bmcremote_${name}":
    path  => "/usr/local/bmcremote/${name}.sh",
    owner => 'root',
    group => 'root',
    mode  => '0700',
  }
  
  # fragment to setup env vars, passwords etc
  concat::fragment {"bmcremote_header_${name}":
      target  => "bmcremote_${name}",
      content => template("bmcremote/setup.erb"),
      order   => '00',
  }
 
  # Make resource names unique
  $configset_keys = keys($settings)
#  $configset_resources = prefix($configset_keys, 'bmcremote_configset_')
  $configset_resources = prefix($configset_keys, "bmcremote_${name}")
 
  bmcremote::configset { $configset_resources:
     target   => "bmcremote_${name}",
     type     => $type,
     settings => $settings,
  }
 
}

