# This class implements the configuration stage of this module. It should not be called directly.
#
# Configuration file defined with `geoip::config_path` will be created using parameter from
# `geoip::config`.
class geoip::config(
  String $licensekey,
  Array[String] $editionids = ['GeoLite2-ASN','GeoLite2-City','GeoLite2-Country'],
  Optional[String] $userid = undef,
  Optional[String] $accountid = undef,
  Optional[Stdlib::Absolutepath] $database_directory = undef,
  Optional[String] $host = undef,
  Optional[String] $proxy = undef,
  Optional[String] $proxy_user_password = undef,
  Optional[Boolean] $preserve_file_times = undef,
  Optional[String] $lock_file = undef,
) {

  $cfg_ensure = $geoip::ensure ? {
    /present/ => 'file',
    default   => $geoip::ensure,
  }

  if $userid and $accountid {
    fail("GeoIP: Can't set both UserID and AccountID. Please choose either one")
  }

  file{ $geoip::config_path:
    ensure  => $cfg_ensure,
    content => epp("geoip/GeoIP.conf.${geoip::config_version}.epp"),
    mode    => '0640',
    group   => 0,
    owner   => 0,
  }

  $srv = $facts['service_provider']
  case $srv {
    /systemd/: {
      contain geoip::systemd::service
    }
    default: {
      warning("unknown service provider (${srv}).")
    } # default
  }
}
