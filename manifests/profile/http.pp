define worldofcontainers::profile::http (
  $version = '1.0.0',
  $repo    = 'ncorrare/worldofcontainers',
  $port    = 80,
  $host    = $::fqdn,
  $cahost,
  $iahost,
) 

{
  include docker
  firewall { "220 allow HTTP connections":
    dport   => $port,
    proto  => tcp,
    action => accept,
  }
  exec {'retrieve-dockerfile':
    command => "/usr/bin/curl https://raw.githubusercontent.com/$repo/$version/web/Dockerfile > /tmp/http-Dockerfile",
    creates => '/tmp/http-Dockerfile',
  }

  file { '/config':
    ensure => directory,
  }->

  file { '/config/config.js':
    ensure  => file,
    content => epp('worldofcontainers/config.js.epp', { 'cahost' => $cahost, 'iahost' => $iahost}),
    }  

    docker::image { 'httpd':
      ensure      => 'present',
      image_tag   => '2.4',
      require     => [Class['docker'], Exec['retrieve-dockerfile'], File['/config/config.js']],
      docker_file => '/tmp/http-Dockerfile',
    }
    docker::run { "httpd-$name":
      image   => 'httpd',
      command => 'init',
      require => Docker::Image['httpd'],
      ports   => ["$port:80"],
      volumes => ["/config:/config:ro"],
    }
}

Worldofcontainers::Profile::Http consumes Citiesapi {
}
Worldofcontainers::Profile::Http consumes Infoapi {
}
