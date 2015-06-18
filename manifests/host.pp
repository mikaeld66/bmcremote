define bmcremote::host(
  $type     = 'idrac8',
  $ip       = '12.34.56.78',
  $user     = 'root',
  $pass     = 'calvin',
  $settings = {
    'name_of_settings_group' => {
      'check' => {},
      'set'   => {},
      'exec'  => {},
    }
  }
) {
info("name: ${name}")
  case $type {
    'idrac8': {
      # device specific values if needed
    }
    default: {
      fail("bmc device type ${type} not set or not supported")
    }   
  }
 
  concat { "bmcremote_${name}":
#    path  => "/etc/bmcremote/hosts/${name}.sh",
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
  $configset_resources = prefix($configset_keys, 'bmcremote_configset_')
 
  bmcremote::configset { $configset_resources:
     target   => "bmcremote_${name}",
     type     => $type,
     settings => $settings,
  }
 
}

