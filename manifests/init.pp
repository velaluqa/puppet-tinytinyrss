# == Class: tinytinyrss
#
# === Parameters
#
# [path] The path to extract tinytinyrss to (default: '/srv/tinytinyrss').
# [user] The user of the webserver (default: 'www-data').
# [archive_url] The archive to install tinytinyrss with (default: 'https://github.com/gothfox/Tiny-Tiny-RSS/archive/1.9.tar.gz').
# [archive_directory] The directory that is extracted by the tar archive (default: 'Tiny-Tiny-RSS-1.9').
#
# === Examples
#
# class { 'tinytinyrss':
#   path  => "/srv/tinytinyrss",
# }
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
  $path              = '/srv/tinytinyrss',
  $user              = 'www-data',
  $archive_url       = 'https://github.com/gothfox/Tiny-Tiny-RSS/archive/1.9.tar.gz',
  $archive_directory = 'Tiny-Tiny-RSS-1.9',
) {

  $extract_dir = "/tmp/${archive_directory}"

  exec { 'tinytinyrss-purge-old':
    path => '/bin:/usr/bin',
    onlyif => "test -f ${path}/ARCHIVE_URL && grep -qv '${archive_url}' ${path}/ARCHIVE_URL",
    command => "bash -c 'rm -rf ${path}/*'",
    user => $user,
  }

  file { $path:
    ensure => 'directory',
    owner => $user,
    require => Exec['tinytinyrss-purge-old'],
  }

  exec { 'tinytinyrss-download':
    path => '/bin:/usr/bin',
    unless => "test -f ${path}/index.php",
    creates => '/tmp/ttr.tar.gz',
    command => "bash -c 'wget -O/tmp/ttr.tar.gz ${archive_url}'",
    require => File[$path],
    user => $user,
  }

  exec { 'tinytinyrss-extract':
    path => '/bin:/usr/bin',
    unless => "test -f ${path}/index.php",
    creates => '/tmp/tinytinyrss',
    command => "bash -c 'cd /tmp; tar xfz ttr.tar.gz'",
    require => [ Exec['tinytinyrss-download'] ],
    user => $user,
  }

  exec { 'tinytinyrss-copy':
    path => '/bin:/usr/bin',
    creates => "${path}/index.php",
    command => "bash -c 'cp -rf ${extract_dir}/* ${path}/'",
    require => Exec['tinytinyrss-extract'],
    user => $user,
  }

  file { "${path}/ARCHIVE_URL":
    content => $archive_url,
    owner => $user,
    require => Exec['tinytinyrss-copy'],
  }

  file { [ '/tmp/ttr.tar.gz', $extract_dir ]:
    ensure => absent,
    recurse => true,
    force => true,
    require => Exec['tinytinyrss-copy'],
  }

  cron { 'tinytinyrss-job':
      ensure  => present,
      minute => '*/10',
      user => $user,
      command => "cd ${path} && /usr/bin/php update.php --feeds --quiet",
      environment => ['PATH="/usr/bin:/bin"'],
  }
} # Class:: tinytinyrss
