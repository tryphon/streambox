# Defaults

Exec {
  path => "/usr/bin:/usr/sbin/:/bin:/sbin:/usr/local/bin:/usr/local/sbin"
}

File {
  checksum => md5, owner => root, group => root
}

import "config.pp"
import "classes/*.pp"

if $stream_1_server != '' {
  file { "/etc/munin/plugins/ping_$stream_1_server":
    ensure => "/usr/share/munin/plugins/ping_",
    notify => Service["munin-node"],
    tag => boot
  }
}
