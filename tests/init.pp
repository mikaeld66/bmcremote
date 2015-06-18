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
$verified_certname = $::trusted['certname']
$dot_a             = split($::verified_certname, '\.')
$verified_host     = $dot_a[0]
$dash_a            = split($::verified_host, '-')

$location          = $::dash_a[0]
$role              = $::dash_a[1]
$hostid            = $::dash_a[2]

## Set runmode to default if it is not provided
#if empty($::runmode) {
#  $runmode='default'
#}
## Query for hash of classes to include
#$classes = hiera_hash('include', {})
## Set array of classes to include for current runmode
#$runmode_classes = $classes[$::runmode]

# Output the node classification data
info("certname=${verified_certname} location=${location} role=${role} hostid=${hostid} runmode=${::runmode}")
#info(join($runmode_classes,' '))



include bmcremote

#bmcremote::host { '129.240.224.80':
#    settings => '',
#}

#bmcremote::idrac_setting { '129.240.224.80/nic.nicconfig.1.legacybootproto':
#    setting => 'PXE',
#}
#
#bmcremote::idrac_setting { '129.240.80.81/brukere.1.navn':
#    setting => 'aaa',
#}
