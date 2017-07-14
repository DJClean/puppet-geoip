#
class geoip::service {
  if $geoip::manage_service {
    case $facts['service_provider'] {
      /systemd/: {
        class{ 'geoip::service::systemd': }
      } # systemd
      default: {
        fail('unknown service provider.')
      } # default
    } # case
  } # if
} # class
