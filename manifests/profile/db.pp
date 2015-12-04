define worldofcontainers::profile::db (
  $dbuser,
  $dbpass,
  $host = $::fqdn,
  $citiesapiip,
  $infoapiip,
){
  $override_options = {
    'mysqld' => {
      'bind-address' => '0.0.0.0',
    }
  }
  firewall { "allow mysql connections from Cities API Servers":
    dport   => 3306,
    source  => $citiesapiip,
    proto  => tcp,
    action => accept,
  }
  firewall { "allow mysql connections from Info API Servers":
    dport   => 3306,
    source  => $infoapiip,
    proto  => tcp,
    action => accept,
  }
  class {'::mysql::server':
    override_options => $override_options,
  }
  mysql::db { $name:
    user     => $dbuser,
    password => $dbpass,
    host     => '%',
    grant    => ['ALL PRIVILEGES'],
  }
}
Worldofcontainers::profile::Db produces Db {
  dbuser => $dbuser,
  dbpass => $dbpass,
  dbhost => $host,
  dbname => $name,
}
Worldofcontainers::Profile::Http consumes Citiesapi {
  $ip = $citiesapiip, 
}
Worldofcontainers::Profile::Http consumes Infoapi {
  $ip = $infoapiip, 
}
