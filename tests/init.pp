# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
include bmcremote

bmcremote::idrac_setting { '129.240.224.80/bios.biosbootsettings.bootmode':
    setting => 'bios',
}

bmcremote::idrac_setting { '129.240.224.80/nic.nicconfig.1.legacybootproto':
    setting => 'PXE',
}
#
#bmcremote::idrac_setting { '129.240.80.81/brukere.1.navn':
#    setting => 'aaa',
#}
