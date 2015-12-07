define worldofcontainers::profile::infoapi (
  $version   = 'master',
  $repo      = 'ncorrare/worldofcontainers',
  $port      = 3000,
  $host      = $::fqdn,
  $dbname,
  $dbhost,
  $dbuser,
  $dbpass,
  $mchost,
  $mcport,
)

{
  include docker
  firewall { "202 allow InfoApi connections from Web Servers":
    dport   => $port,
    proto  => tcp,
    action => accept,
  }
  exec {'retrieve-dockerfile-infoapi':
    command => "/usr/bin/curl https://raw.githubusercontent.com/$repo/$version/api/Dockerfile > /tmp/infoapi-Dockerfile",
    creates => '/tmp/infoapi-Dockerfile',
  }
  file { '/config':
    ensure  => directory,
  } ->
  file { '/config/config.yaml':
    ensure  => file,
    content => epp('worldofcontainers/config.yaml.epp'),
  }

  docker::image { 'infoapi':
    ensure      => 'present',
    image_tag   => 'latest',
    require     => [Class['docker'], Exec['retrieve-dockerfile-infoapi'], File['/config/config.yaml']],
    docker_file => '/tmp/infoapi-Dockerfile',
  }

  docker::run { "infoapi-$name":
    image   => 'infoapi',
    command => 'init',
    require => Docker::Image['infoapi'],
    ports   => ["$port,3000"],
    volumes => ["/config:/config:ro"],
  }
}

Worldofcontainers::Profile::Infoapi produces Infoapi {
  iahost => "$host:$port",
  } 

  Worldofcontainers::Profile::Infoapi consumes Cache {
    mchost => $host,
    mcport => $port,
  }

  Worldofcontainers::Profile::Infoapi consumes Db {
  }
