define worldofcontainers::profile::citiesapi (
  $version   = 'master',
  $repo      = 'ncorrare/worldofcontainers',
  $port      = 4000,
  $cah       = $::fqdn,
  $dbname,
  $dbhost,
  $dbuser,
  $dbpass,
  $mchost,
  $mcport,
)

{
  include docker
  firewall { "201 allow CitiesApi connections from Web Servers":
    dport   => $port,
    proto  => tcp,
    action => accept,
  }
  exec {'retrieve-dockerfile-citiesapi':
    command => "/usr/bin/curl https://raw.githubusercontent.com/$repo/$version/api/Dockerfile > /tmp/citiesapi-Dockerfile",
    creates => '/tmp/citiesapi-Dockerfile',
  }
  file { '/config':
    ensure  => directory,
  } ->
  file { '/config/config.yaml':
    ensure  => file,
    content => epp('worldofcontainers/config.yaml.epp', { 'dbname' => $dbname, 'dbhost' => $dbhost, 'dbuser' => $dbuser, 'dbpass' => $dbpass, 'mchost' => $mchost, 'mcport' => $mcport }),
  }

  docker::image { 'citiesapi':
    ensure      => 'present',
    image_tag   => 'latest',
    require     => [Class['docker'], Exec['retrieve-dockerfile-citiesapi'], File['/config/config.yaml']],
    docker_file => '/tmp/citiesapi-Dockerfile',
  }

  docker::run { "citiesapi-$name":
    image   => 'citiesapi',
    command => 'ruby api.rb',
    require => Docker::Image['citiesapi'],
    ports   => ["$port:3000"],
    volumes => ["/config:/config:ro"],
  }
}

Worldofcontainers::Profile::Citiesapi produces Citiesapi {
  cahost => "$cah:$port",
  } 

  Worldofcontainers::Profile::Citiesapi consumes Cache {
    mchost => $host,
    mcport => $port,
  }

  Worldofcontainers::Profile::Citiesapi consumes Db {
  }
