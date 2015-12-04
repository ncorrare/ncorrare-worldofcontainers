define worldofcontainers::profile::http (
  $version = $worldofcontainers::params::version,
  $repo    = $worldofcontainers::params::repo,
  $port    = 80,
  $host    = $::fqdn,
  $cahost,
  $iahost,
) inherits worldofcontainers::params

{
  include docker
  exec {'retrieve-dockerfile':
    command => "/usr/bin/curl -O /tmp/http-dockerfile https://raw.githubusercontent.com/$repo/$version/web/Dockerfile",
    creates => '/tmp/http-Dockerfile',
  }

  file { '/config':
    ensure => directory,
  }

  file { '/config/config.js':
    ensure  => file,
    content => epp('config.js.epp'),
    require => File['/config'],
    }  

    docker::image { 'httpd':
      ensure      => 'present',
      image_tag   => '2.4',
      require     => [Class['docker'], Exec['retrieve-dockerfile'], File['/tmp/config.js']],
      docker_file => '/tmp/http-Dockerfile',
    }
    docker::run { $name:
      image   => 'httpd',
      command => 'init',
      require => Docker::Image['httpd'],
      ports   => [$port,80],
    }
}

Worldofcontainers::Profile::Http produces Http {
}
Worldofcontainers::Profile::Http consumes Citiesapi {
}
Worldofcontainers::Profile::Http consumes Infoapi {
}
