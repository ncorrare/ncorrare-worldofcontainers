define worldofcontainers::profile::citiesapi (
  $version = '1.0.0',
  $repo    = 'ncorrare/worldofcontainers',
  $port    = 3000,
  $host    = $::fqdn,
  $dbname,
  $dbhost,
  $dbuser,
  $dbpass,
  $mchost,
  $mcport,
) {
  include docker
  firewall { "210 allow CitiesApi connections from Web Servers":
    dport  => $port,
    proto  => tcp,
    action => accept,
  }
  exec {'retrieve-dockerfile-citiesapi':
    command => "/usr/bin/curl https://raw.githubusercontent.com/$repo/$version/api/Dockerfile > /tmp/citiesapi-Dockerfile",
    creates => '/tmp/citiesapi-Dockerfile',
  }
  file { '/config':
    ensure => directory,
  }

  file { '/config/config.yaml':
    ensure  => file,
    content => epp('worldofcontainers/config.yaml.epp'),
    require => File['/config'],
  }

  docker::image { 'citiesapi':
    ensure      => 'present',
    image_tag   => '2.2.1',
    require     => [Class['docker'], Exec['retrieve-dockerfile-citiesapi'], File['/tmp/config.yaml']],
    docker_file => '/tmp/citiesapi-Dockerfile',
  }

  docker::run { "citiesapi-$name":
    image   => 'ruby',
    command => 'init',
    require => Docker::Image['citiesapi'],
    ports   => [$port,3000],
  }
}

Worldofcontainers::Profile::Citiesapi produces Citiesapi {
  cahost => "$host:port"
  } 

  Worldofcontainers::Profile::Citiesapi consumes Cache {
    mchost => $host,
    mcport => $port
  }

  Worldofcontainers::Profile::Citiesapi consumes Db {
  }

