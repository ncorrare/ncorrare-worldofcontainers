define worldofcontainers::profile::db (
  $dbuser,
  $dbpass,
  $host = $::networking['interfaces']['enp0s8']['ip'],
){
  $override_options = {
    'mysqld' => {
      'bind-address' => '0.0.0.0',
    }
  }
  firewall { "200 allow mysql connections":
    dport  => 3306,
    proto  => tcp,
    action => accept,
  }
  class {'::mysql::server':
    override_options => $override_options,
  }
  file {'/tmp/schema.sql':
    ensure => file,
    source => 'puppet:///modules/worldofcontainers/schema.sql',
  }

  mysql::db { $name:
    user     => $dbuser,
    password => $dbpass,
    host     => '%',
    grant    => ['ALL PRIVILEGES'],
    sql      => '/tmp/schema.sql',
    require  => File['/tmp/schema.sql'],
  }
}
Worldofcontainers::Profile::Db produces Db {
  dbuser => $dbuser,
  dbpass => $dbpass,
  dbhost => $host,
  dbname => $name,
}
