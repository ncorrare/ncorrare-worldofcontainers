define worldofcontainers::profile::api (
  $version = $worldofcontainers::params::version,
  $repo    = $worldofcontainers::params::repo,
  $port    = 3000,
  $host    = $::fqdn
  $dbname,
  $dbhost,
  $dbuser,
  $dbpass,
  $mchost,
) inherits worldofcontainers::params

{
  include docker
  exec {'retrieve-dockerfile':
    command => "/usr/bin/curl -O /tmp/api-Dockerfile https://raw.githubusercontent.com/$repo/$version/api/Dockerfile",
    creates => '/tmp/api-Dockerfile',
  }
  file { '/tmp/config.yaml':
    ensure  => file,
    content => epp('config.yaml.epp'),
  }

  docker::image { 'ruby':
    ensure      => 'present',
    image_tag   => '2.2.1',
    require     => [Class['docker'], Exec['retrieve-dockerfile'], File['/tmp/config.yaml']],
    docker_file => '/tmp/api-Dockerfile',
  }

  docker::run { api-$name:
    image   => 'ruby',
    command => 'init',
    require => Docker::Image['ruby'],
    ports   => [$port,3000],
  }
}

Worldofcontainers::Profile::Api produces Infoapi {
  $iahost = "$host:$port",
  $ip     = $host,
  } 

  Worldofcontainers::Profile::Api consumes Cache {
    $mchost = $host,
    $mcport = $port,
  }

  Worldofcontainers::Profile::Api consumes Db {
  }
