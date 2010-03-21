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

$darkice_user = "stream"
include darkice
include apache
include apache::dnssd
include streamcontrol
