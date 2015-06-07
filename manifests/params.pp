# == Class bmcremote::params
#
# This class is meant to be called from bmcremote.
# It sets variables according to platform.
#

class bmcremote::params {

  $lockfile = "/tmp/bmcremote.lck"

  case $::osfamily {
    'RedHat': {
      case $::manufacturer {
        /(Dell.*)|(Red Ha.*)/:  {
          $package_name             = 'srvadmin-idracadm'
#         No point in checking architecture etc since this will be running on a remote host
#          $repo_indep_mirrorlist    = "http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el${::lsbmajdistrelease}&basearch=\$basearch&native=1&dellsysidpluginver=\$dellsysidpluginver"
          $repo_indep_mirrorlist    = "http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el7&basearch=\$basearch&native=1"
          $repo_indep_gpgkey        = 'http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-dell'
#          $repo_specific_mirrorlist = "http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el${::lsbmajdistrelease}&basearch=\$basearch&native=1&sys_ven_id=\$sys_ven_id&sys_dev_id=\$sys_dev_id&dellsysidpluginver=\$dellsysidpluginver"
          $repo_specific_mirrorlist = "http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el7&basearch=\$basearch&native=1&sys_ven_id=\$sys_ven_id&sys_dev_id=\$sys_dev_id"
          $repo_specific_gpgkey     = 'http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-dell'
        }
        default:  {
          fail("${::manufacturer} not supported")
        }
      }
    }
    default: {
      fail("${::osfamily} not supported")
    }
  }
}
