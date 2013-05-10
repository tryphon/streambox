# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Enable threaded mode
# config.threadsafe!

# Use a different logger for distributed setups
require 'syslog/logger'
config.logger = Syslog::Logger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

config.after_initialize do
  PuppetConfiguration.configuration_file = "/var/etc/puppet/manifests/config.pp"
  PuppetConfiguration.system_update_command = "sudo /usr/local/sbin/launch-puppet"
  
  # SavePoint.timestamp_file = "/boot/config.pp"
  SavePoint.save_command = "sudo /usr/local/sbin/save-puppet-config"

  Monitoring.munin_resources_directory = "/var/www/munin/local/"

  # FIXME see #784
  require 'box'
  Box::CLI::Root.new.setup Box::CLI::Root.setup_file

  Box::Release.install_command = "sudo /usr/local/sbin/box-upgrade"
end
