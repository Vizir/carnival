$ar_databases = ['activerecord_unittest', 'activerecord_unittest2']
$as_vagrant   = 'sudo -u vagrant -H bash -l -c'
$home         = '/home/vagrant'

Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

group { 'puppet':
  ensure => 'present'
}

exec { 'apt-get update':
  command => '/usr/bin/apt-get update',
  timeout => 0
} ->

exec { 'apt-get upgrade':
  command => '/usr/bin/apt-get upgrade -y',
  timeout => 0,
  require => Exec['apt-get update']
} ->

# --- Packages -----------------------------------------------------------------

package { 'build-essential':
  ensure => installed,
  require => Exec['apt-get upgrade']
}

package { 'git':
  ensure => installed,
  require => Package['build-essential']
}

package { 'git-core':
  ensure => installed,
  require => Package['git']
}

# Nokogiri dependencies.
package { ['libxml2', 'libxml2-dev', 'libxslt1-dev']:
  ensure => installed,
  require => Package['git-core']
}

# ExecJS runtime.
package { 'nodejs':
  ensure => installed,
  require => Package['git-core']
}

# vim.
package { 'vim':
  ensure => installed,
  require => Package['nodejs']
}


package { 'imagemagick':
  ensure => installed,
  require => Package['vim']
}


# RedisServer.
package { 'redis-server':
  ensure => installed,
  require => Package['vim']
}

package { 'libmysqlclient15-dev':
  ensure => installed,
  require => Package['redis-server']
}

package { 'postgresql-client':
  ensure => installed,
  require => Package['libmysqlclient15-dev']
}

package { 'libpq-dev':
  ensure => installed,
  require => Package['postgresql-client']
}

package { 'wkhtmltopdf':
  ensure => installed,
  require => Package['libmysqlclient15-dev']
}

package { 'xvfb':
  ensure => installed,
  require => Package['libmysqlclient15-dev']
}

package { 'curl':
  ensure => installed,
  require => Package['libmysqlclient15-dev']
}


# --- Postgre --------------------------------------------------------------------

class { 'postgresql':
  charset => 'UTF8',
  locale  => 'en_US',
  require => Package['postgresql-client']
}->

class { 'postgresql::server':
  config_hash => {
    'manage_pg_hba_conf'         => false,
  },
  require => Class['postgresql']
}

file { 'pg_hba.conf':
  path => '/etc/postgresql/9.1/main/pg_hba.conf',
  source => '/vagrant/files/pg_hba.conf',
  require => Class['postgresql::server']
}

exec { "restart postgresql":
  command => '/etc/init.d/postgresql restart',
  timeout => 0,
  logoutput => true,
  require => File["pg_hba.conf"],
}


# --- MySQL --------------------------------------------------------------------

class install_mysql {
  class { 'mysql':
    require => Package['curl']
  }

  class { 'mysql::server':
    config_hash => { 'root_password' => '' },
    require => Package['curl']
  }

  database { $ar_databases:
    ensure  => present,
    charset => 'utf8',
    require => Class['mysql::server']
  }

  database_user { 'rails@localhost':
    ensure  => present,
    require => Class['mysql::server']
  }

  database_grant { ['rails@localhost/activerecord_unittest', 'rails@localhost/activerecord_unittest2', 'rails@localhost/inexistent_activerecord_unittest']:
    privileges => ['all'],
    require    => Database_user['rails@localhost']
  }
}
class { 'install_mysql':
  require => Package['curl']
}

# --- Ruby ---------------------------------------------------------------------

exec { 'install_rvm':
  command => "${as_vagrant} 'curl -L https://get.rvm.io | bash -s stable'",
  creates => "${home}/.rvm/bin/rvm",
  require => Package['curl']
}

exec { 'install_ruby':
  # We run the rvm executable directly because the shell function assumes an
  # interactive environment, in particular to display messages or ask questions.
  # The rvm executable is more suitable for automated installs.
  #
  # Thanks to @mpapis for this tip.
  command => "${as_vagrant} '${home}/.rvm/bin/rvm install 1.9.3 && rvm --fuzzy alias create default 1.9.3'",
  creates => "${home}/.rvm/bin/ruby",
  require => Exec['install_rvm']
}

exec { "${as_vagrant} 'gem install bundler --no-rdoc --no-ri'":
  creates => "${home}/.rvm/bin/bundle",
  require => Exec['install_ruby']
}
