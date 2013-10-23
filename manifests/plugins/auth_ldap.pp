class tinytinyrss::plugins::auth_ldap (
  $archive_url = "http://blog.sleeplessbeastie.eu/assets/uploads/2013/06/tiny_tiny_rss-auth_ldap.tgz"
) {
  $path = $tinytinyrss::path
  $user = $tinytinyrss::user
  $plugin_path = "${path}/plugins/auth_ldap"

  if(!defined(Package['php-net-ldap2'])) {
    package { 'php-net-ldap2': }
  }

  file { $plugin_path:
    ensure => 'directory',
    owner => $user,
    require => File[$path],
  }

  exec { 'tinytinyrss-auth_ldap-purge-old':
    path => '/bin:/usr/bin',
    onlyif => "test -f ${plugin_path}/ARCHIVE_URL && grep -qv '${archive_url}' ${plugin_path}/ARCHIVE_URL",
    command => "bash -c 'rm -rf ${plugin_path}/*'",
    user => $user,
    require => File[$plugin_path],
  }

  exec { 'tinytinyrss-auth_ldap-download':
    path => '/bin:/usr/bin',
    unless => "test -f ${plugin_path}/init.php",
    creates => '/tmp/ttr-auth-ldap.tar.gz',
    command => "bash -c 'wget -O/tmp/ttr-auth-ldap.tar.gz ${archive_url}'",
    require => [ File[$plugin_path], Exec['tinytinyrss-auth_ldap-purge-old'] ],
    user => $user,
  }

  exec { 'tinytinyrss-auth_ldap-extract':
    path => '/bin:/usr/bin',
    unless => "test -f ${plugin_path}/init.php",
    creates => '/tmp/auth_ldap',
    command => "bash -c 'cd /tmp; tar xfz ttr-auth-ldap.tar.gz'",
    require => [ Exec['tinytinyrss-auth_ldap-download'] ],
    user => $user,
  }

  exec { 'tinytinyrss-auth_ldap-copy':
    path => '/bin:/usr/bin',
    creates => "${plugin_path}/init.php",
    command => "bash -c 'cp -rf /tmp/auth_ldap/* ${plugin_path}/'",
    require => Exec['tinytinyrss-auth_ldap-extract'],
    user => $user,
  }

  file { "${plugin_path}/ARCHIVE_URL":
    content => $archive_url,
    owner => $user,
    require => Exec['tinytinyrss-auth_ldap-copy'],
  }

  file { [ '/tmp/ttr-auth-ldap.tar.gz', '/tmp/auth_ldap' ]:
    ensure => absent,
    recurse => true,
    force => true,
    require => Exec['tinytinyrss-auth_ldap-copy'],
  }
}
