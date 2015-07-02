$verified_certname = $::trusted['certname']
$dot_a             = split($::verified_certname, '\.')
$verified_host     = $dot_a[0]
$dash_a            = split($::verified_host, '-')

$location          = $::dash_a[0]
$role              = $::dash_a[1]
$hostid            = $::dash_a[2]

# Output the node classification data
info("certname=${verified_certname} location=${location} role=${role} hostid=${hostid} runmode=${::runmode}")

include bmcremote
