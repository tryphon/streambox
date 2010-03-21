class darkice {
  package { darkice: }

  file { "/etc/darkice/darkice.cfg":
    ensure => "/var/etc/darkice/darkice.cfg"
  }

  file { "/etc/darkice":
    ensure => directory
  }

  file { "/etc/init.d/darkice":
    source => "$source_base/files/darkice/darkice.init",
    require => File["/etc/default/darkice"],
    mode => 775
  }    
  exec { "update-rc.d darkice defaults":
    require => File["/etc/init.d/darkice"],
    creates => "/etc/rc0.d/K20darkice"
  }

  file { "/etc/default/darkice":
    source => "$source_base/files/darkice/darkice.default",
    require => [File["/usr/local/bin/darkice-safe"], User[$darkice_user]]
  }

  file { "/usr/local/bin/darkice-safe":
    source => "$source_base/files/darkice/darkice-safe",
    require => Package[darkice],
    mode => 775
  }    
}
