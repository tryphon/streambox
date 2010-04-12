import "defaults"
import "classes/*.pp"

import "box"

$source_base="/tmp/puppet"

$box_name="streambox"

include users
include network
include network::interfaces

include linux::kernel-2-6-30
include syslog
include smtp
include nano
include ssh

include dbus::readonly
include avahi

include apt
include apt::tryphon
include puppet
include sudo

include alsa::common
include alsa::oss # troubles with alsa & darkice 
include tuner

$darkice_user = "stream"
include darkice::full
include apache
include apache::dnssd
include streamcontrol

include munin::readonly
include munin-node::local
