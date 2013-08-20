# == Class: tinytinyrss
#
# === Parameters
#
# TODO: Add parameters
#
# === Examples
#
# TODO: Add examples
#
# === Authors
#
# Arthur Leonard Andersen <leoc.git@gmail.com>
#
# === Copyright
#
# See LICENSE file, Arthur Leonard Andersen (c) 2013

# Class:: tinytinyrss
#
#
class tinytinyrss (
  $tinytinyrss_path              = $tinytinyrss::params::tinytinyrss_path,
  $tinytinyrss_user              = $tinytinyrss::params::tinytinyrss_user,
  $tinytinyrss_title             = $tinytinyrss::params::tinytinyrss_title,
  $tinytinyrss_db_type           = $tinytinyrss::params::tinytinyrss_db_type,
  $tinytinyrss_db_file           = $tinytinyrss::params::tinytinyrss_db_file,
  $tinytinyrss_db_host           = $tinytinyrss::params::tinytinyrss_db_host,
  $tinytinyrss_db_name           = $tinytinyrss::params::tinytinyrss_db_name,
  $tinytinyrss_db_user           = $tinytinyrss::params::tinytinyrss_db_user,
  $tinytinyrss_db_password       = $tinytinyrss::params::tinytinyrss_db_password,
  $tinytinyrss_db_port           = $tinytinyrss::params::tinytinyrss_db_port,
  $tinytinyrss_db_prefix         = $tinytinyrss::params::tinytinyrss_db_prefix
) inherits tinytinyrss::params {
  file { $tinytinyrss_path:
    ensure => "directory",
    owner => $tinytinyrss_user,
  }

  exec { "tinytinyrss-download":
    path => "/bin:/usr/bin",
    command => "bash -c 'cd /tmp; wget https://github.com/gothfox/Tiny-Tiny-RSS/archive/1.9.tar.gz; mkdir -p /tmp/tinytinyrss; tar xvfz /tmp/1.9.tar.gz; cp -rf /tmp/Tiny-Tiny-RSS-1.9/* ${tinytinyrss_path}/'",
    require => File[$tinytinyrss_path],
    user => $tinytinyrss_user,
  }
} # Class:: tinytinyrss
