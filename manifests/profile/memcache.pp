define worldofcontainers::profile::memcache (
  $port = 11211,
  $host = $::fqdn,
  $citiesapiip,
  $infoapiip,
)

{
  firewall { "allow memcache connections from Cities API Servers":
    dport   => $port,
    source  => $citiesapiip,
    proto  => tcp,
    action => accept,
  }
  firewall { "allow memcache connections from Info API Servers":
    dport   => $port,
    source  => $infoapiip,
    proto  => tcp,
    action => accept,
  }
  include docker
  docker::image { 'memcached':
    ensure      => 'present',
    image_tag   => 'latest',
    require     => Class['docker'],
  }
  docker::run { $name:
    image   => 'memcached',
    command => 'memcached -m 64',
    require => Docker::Image['memcached'],
    ports   => [$port,11211],
  }
  }  
  Worldofcontainers::Profile::Memcache produces Cache {
  }
  Worldofcontainers::Profile::Http consumes Citiesapi {
    $ip = $citiesapiip,
  }
  Worldofcontainers::Profile::Http consumes Infoapi {
    $ip = $infoapiip,
  }

