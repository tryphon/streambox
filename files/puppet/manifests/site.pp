# Defaults

Exec { 
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" 
}

File { 
  checksum => md5, owner => root, group => root
}

import "config.pp"
import "classes/*.pp"

# Use tag boot for resources required at boot (network files, etc ..)

file { "/var/etc/network":
  ensure => directory,
  tag => boot
}

file { "/var/etc/network/interfaces":
  content => template("/etc/puppet/templates/interfaces"),
  notify => Exec["restart-networking"],
  tag => boot
}

file { "/etc/network/interfaces":
  ensure => "/var/etc/network/interfaces"
}

exec { "restart-networking": 
  command => "/sbin/ifdown eth0 && /sbin/ifup eth0",
  refreshonly => true
}

file { "/var/lib/streamcontrol/db":
  ensure => directory,
  owner => www-data,
  group => www-data,
  tag => boot
}

exec { "create-streamcontrol-db": 
  command => "install --owner=www-data --group=www-data --mode=664 /usr/share/streamcontrol/db/production.sqlite3 /var/lib/streamcontrol/db",
  creates => "/var/lib/streamcontrol/db/production.sqlite3",
  require => File["/var/lib/streamcontrol/db"],
  tag => boot
}

file { "/var/etc/fm/":
  ensure => directory,
  tag => boot
}

file { "/var/etc/fm/fm.conf":
  content => template("/etc/puppet/templates/fm.conf"),
  notify => Service[fm],
  tag => boot
}

service { fm:
  ensure => running,
  hasrestart => true
}

file { "/var/etc/darkice/":
  ensure => directory,
  tag => boot
}

file { "/var/etc/darkice/darkice.cfg":
  content => template("/etc/puppet/templates/darkice.cfg"),
  notify => Service[darkice],
  tag => boot
}

service { darkice:
  ensure => running,
  hasrestart => true
}

exec { "copy-var-model":
  creates => "/var/log/dmesg",
  command => "cp -a /var/log.model/* /var/log/",
  tag => boot
}

exec { "amixerconf":
  command => "/usr/local/bin/amixerconf",
  tag => boot
}

if $stream_1_server != '' {
  file { "/etc/munin/plugins/ping_$stream_1_server":
    ensure => "/usr/share/munin/plugins/ping_",
    notify => Service["munin-node"],
    tag => boot
  }
}
