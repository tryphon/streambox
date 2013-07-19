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
