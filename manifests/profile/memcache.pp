define worldofcontainers::profile::memcache (
  $port = 11211,
  $host = $::fqdn,
)

{
  firewall { "201 allow memcache connections from API Servers":
    dport  => $port,
    proto  => tcp,
    action => accept,
  }
  include docker
  docker::image { 'memcached':
    ensure      => 'present',
    image_tag   => 'latest',
  }
  docker::run { "memcache-$name":
    image   => 'memcached',
    command => 'memcached -m 64',
    require => Docker::Image['memcached'],
    ports   => ["$port:11211"],
  }
  }  
  Worldofcontainers::Profile::Memcache produces Cache {
  }

