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

if $stream_1_server != '' {
  file { "/etc/munin/plugins/ping_$stream_1_server":
    ensure => "/usr/share/munin/plugins/ping_",
    notify => Service["munin-node"],
    tag => boot
  }
}
