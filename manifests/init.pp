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

  cron::job {
    'tinytinyrss-job':
      minute => '*/10',
      hour => '*',
      date => '*',
      month => '*',
      weekday => '*',
      user => $user,
      command => "cd ${tinytinyrss_path} && /usr/bin/php update.php --feeds --quiet",
      environment => ['PATH="/usr/bin:/bin"'],
      require => Exec['tinytinyrss-copy'],
  }
} # Class:: tinytinyrss
