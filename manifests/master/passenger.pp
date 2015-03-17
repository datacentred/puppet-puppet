# == Class: puppet::master::passenger
#
# Deploy a standalone puppet master with an apache ssl passenger
# frontend
#
class puppet::master::passenger {

  include ::apache
  include ::apache::mod::passenger
  include ::puppet::master

  $ssldir = puppet_ssldir()

  file { [
    '/etc/puppet/rack',
    '/etc/puppet/rack/public',
    '/etc/puppet/rack/tmp',
  ]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->

  file { '/etc/puppet/rack/config.ru':
    ensure => file,
    source => 'puppet:///modules/puppet/config.ru',
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0644',
  } ->

  apache::vhost { 'puppetmaster':
    docroot           => '/etc/puppet/rack/public/',
    port              => '8140',
    ssl               => true,
    ssl_protocol      => '-ALL +SSLv3 +TLSv1',
    ssl_cipher        => 'ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:-LOW:-SSLv2:-EXP',
    ssl_cert          => "${ssldir}/certs/${::fqdn}.pem",
    ssl_key           => "${ssldir}/private_keys/${::fqdn}.pem",
    ssl_chain         => "${ssldir}/certs/ca.pem",
    ssl_ca            => "${ssldir}/certs/ca.pem",
    ssl_crl_check     => 'chain',
    ssl_crl           => "${ssldir}/crl.pem",
    ssl_verify_client => 'optional',
    ssl_verify_depth  => '1',
    ssl_options       => '+StdEnvVars +ExportCertData',
    request_headers   => [
      'unset X-Forwarded-For',
      'set X-SSL-Subject %{SSL_CLIENT_S_DN}e',
      'set X-Client-DN %{SSL_CLIENT_S_DN}e',
      'set X-Client-Verify %{SSL_CLIENT_VERIFY}e',
    ],
    rack_base_uris    => '/',
    directories       => {
      path           => '/etc/puppet/rack/public/',
      options        => 'None',
      allow_override => 'None',
    },
  }

  Class['::puppet::master'] -> Class['::puppet::master::passenger']
  # TODO: Encapsulation fail
  Class['::puppet::config'] ~> Class['::apache::service']

}
