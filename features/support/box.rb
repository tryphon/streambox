Before do
  print "0"
  system "ssh streambox.local 'rm -f /var/etc/puppet/manifests/config.pp && /usr/local/sbin/launch-puppet boot' > /dev/null 2>&1"
end
