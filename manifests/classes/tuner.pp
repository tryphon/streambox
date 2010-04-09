class tuner {
  package { radio: }

  file { "/lib/firmware/dvb-fe-tda10046.fw":
    source => "$source_base/files/tuner/dvb-fe-tda10046.fw",
    mode => 644
  }
}
