define worldofcontainers::profile::db (
  $dbuser,
  $dbpass,
  $host = $::fqdn,
){
  $override_options = {
    'mysqld' => {
      'bind-address' => '0.0.0.0',
    }
  }
  firewall { "allow mysql connections from API Servers":
    dport   => 3306,
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
Worldofcontainers::profile::Db produces Db {
  dbuser => $dbuser,
  dbpass => $dbpass,
  dbhost => $host,
  dbname => $name,
}
