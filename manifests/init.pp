# Class: worldofcontainers
# ===========================
#
# Full description of class worldofcontainers here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'worldofcontainers':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2015 Your name here, unless otherwise noted.
#
application worldofcontainers (
  $dbuser  = 'container',
  $dbpass  = 'c0nt41n3r',
) {
  worldofcontainers::profile::db { $name:
    dbuser => $dbuser,
    dbpass => $dbpass,
    export => Db[$name],
  }
  worldofcontainers::profile::memcache { $name:
    export => Cache[$name],
  }
  worldofcontainers::profile::citiesapi { $name:
    consume => [Db[$name],Cache[$name]],
    port    => 3000,
    export  => Citiesapi[$name],
  }
  worldofcontainers::profile::infoapi { $name:
    consume => [Db[$name],Cache[$name]],
    port    => 4000,
    export  => Infoapi[$name],
  }
  worldofcontainers::profile::http { $name:
    consume => [Citiesapi[$name],Infoapi[$name]],
  }
}
