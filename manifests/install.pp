# == Class bmcremote::install
#
# This class is called from bmcremote for install.
#
class bmcremote::install (
  ) inherits bmcremote::params {

  case $::osfamily {

    'RedHat' : {

      package { $::bmcremote::package_name:
          ensure => present,
      }

      ########################################
      # Create the repo
      ########################################
      yumrepo { 'dell-omsa-indep':
        descr          => 'Dell OMSA repository - Hardware     independent',
        enabled        => 1,
        mirrorlist     => $bmcremote::params::repo_indep_mirrorlist,
        gpgcheck       => 1,
        gpgkey         => $bmcremote::params::repo_indep_gpgkey,
        failovermethod => 'priority',
#        require        => Package['dell-omsa-repository'],
      }


      ########################################
      # GPG-KEY Management
      ########################################
      file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-dell':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => 'puppet:///modules/bmcremote/RPM-GPG-KEY-dell',
      }
      exec { 'dell-RPM-GPG-KEY-dell':
        command     => '/bin/rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-dell',
        subscribe   => File['/etc/pki/rpm-gpg/RPM-GPG-KEY-dell'],
        refreshonly => true,
      }

      file { '/usr/local/sbin/ensure_idrac_settings.sh':
        ensure => 'present',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => 'puppet:///modules/bmcremote/ensure_idrac_settings.sh',
      }
    }
  }
}
