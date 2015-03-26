import "defaults"
import "classes/*.pp"
import "config"

import "box"

$source_base="/tmp/puppet"

include box

$amixerconf_mode="capture"
include box::audio

include apache
include apache::dnssd
include streamcontrol

$darkice_user="stream"
include users
include tuner
include go-broadcast::local

include munin-node::local

include icecast2
