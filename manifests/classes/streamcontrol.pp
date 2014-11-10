class streamcontrol {

  # FIXME troubles with some packages from debian.tryphon.eu lenny-backports
  file { "/etc/apt/apt.conf.d/80Unauthenticated":
    content => "APT::Get::AllowUnauthenticated 1;\n",
    before => Package[libapache2-mod-passenger]
  }

  include apache::passenger
  include ruby::bundler
  include apt::tryphon::dev

  file { "/etc/streamcontrol/database.yml":
    source => "$source_base/files/streamcontrol/database.yml",
    require => Package[streamcontrol]
  }
  file { "/etc/streamcontrol/production.rb":
    source => "$source_base/files/streamcontrol/production.rb",
    require => Package[streamcontrol]
  }
  package { streamcontrol:
    ensure => "0.17-1+build35",
    require => [Apt::Source[tryphon-dev], Package[libapache2-mod-passenger]]
  }

  readonly::mount_tmpfs { "/var/lib/streamcontrol": }

  file { "/etc/puppet/manifests/classes/streamcontrol.pp":
    source => "puppet:///files/streamcontrol/manifest.pp"
  }

  # Required for delayed_job.log ...
  file { "/var/log.model/streamcontrol":
    ensure => directory,
    owner => www-data
  }

}
