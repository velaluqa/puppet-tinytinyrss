# Puppet-tinytinyrss

A puppet module to easily deploy tinytinyrss.

## Usage

This would be an example of how to use this module.
You may

```
# Create the database (via puppetlabs/mysql)
mysql::db { "tinytinyrss":
  user => "tinytinyrss",
  password => "secret",
  host => "localhost",
  require => Class['mysql::server'],
}

# Setup nginx to serve tinytinyrss (via jfryman/nginx)
class { 'nginx': }

# Setup a sufficient php5 installation via the nodes/php puppet module
class { 'php::cli': ensure => present }
class { 'php::fpm::daemon': ensure => running }
class { 'php::extension::mysql': }

php::fpm::conf { 'www':
  listen  => '/var/run/php5-fpm.sock',
  user    => 'www-data',
}

class { 'tinytinyrss':
  path => "/srv/tinytinyrss",
  user => "www-data",
}

nginx::resource::vhost { 'rss.domain.tld':
  ensure                 => present,
  www_root               => '/srv/tinytinyrss',
  php_fpm                => 'unix:/var/run/php5-fpm.sock',
  rewrite_www_to_non_www => true,
  require                => Class['tinytinyrss'],
}
```

## Contribute

Want to help - send a pull request.
