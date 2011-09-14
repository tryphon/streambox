import "defaults"
import "classes/*.pp"
import "config"

import "box"

$source_base="/tmp/puppet"

$box_name="streambox"
include box

$amixerconf_mode="capture"
include box::audio

include apache
include apache::dnssd
include streamcontrol

$darkice_user="stream"
include users
include tuner
include darkice::full

include munin-node::local

include icecast2
