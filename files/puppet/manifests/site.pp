# Defaults

Exec { 
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin" 
}

File { 
  checksum => md5, owner => root, group => root
}

import "config.pp"

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
  tag => boot
}

exec { "create-streamcontrol-db": 
  command => "cp /usr/share/streamcontrol/db/production.sqlite3 /var/lib/streamcontrol/db && chown www-data /var/lib/streamcontrol/db/production.sqlite3",
  creates => "/var/lib/streamcontrol/db/production.sqlite3",
  require => File["/var/lib/streamcontrol/db"],
  tag => boot
}

file { "/var/etc/darkice/":
  ensure => directory,
  tag => boot
}

file { "/var/etc/darkice/darkice.cfg":
  content => template("/etc/puppet/templates/darkice.cfg"),
  notify => Exec[darkice-restart],
  tag => boot
}

exec { darkice-restart:
  command => "pkill -f /usr/bin/darkice",
  refreshonly => true
}

file { "/var/etc/resolv.conf":
  ensure => present,
  tag => boot
}

file { "/var/log":
  ensure => directory,
  recurse => true,
  source => "/var/log.model",
  tag => boot
}

exec { "amixerconf":
  command => "/usr/local/bin/amixerconf",
  tag => boot
}
