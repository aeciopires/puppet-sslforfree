# Class: params
#
# Define parametros e valores padrao do modulo.
# Sets parameters and default values of the module.
#
# Atencao: 
#   Alguns parametros podem ter valores customizados de acordo com o servidor.
#   Some parameters may have custom values according to the server.
#
class puppet_sslforfree::params {

  #Espaco requerido: 2 MB ou 2.000.000 bytes
  $space_required       = hiera('space_required', 2000000)
  $tmp_dir              = hiera('tmp_dir', '/tmp')
  $file_hiera           = '/etc/puppetlabs/code/hiera.yaml'

  #Atribuicoes de variaveis de acordo com a distribuicao e versao GNU/Linux 
  case $::operatingsystem {
    'debian','ubuntu': {
      $java_cacert     = '/usr/lib/jvm/java-8-oracle/jre/lib/security/cacerts'
      $distro_downcase = 'ubuntu'
    }
    'centos','redhat': {
      $java_version_redhat = '1.8.0_74'
      $java_cacert         = "/usr/java/jdk${java_version_redhat}/jre/lib/security/cacerts"
      $distro_downcase     = 'redhat'
    }
    default: {
      fail('[ERRO] S.O NAO suportado.')
    }
  }

  $manage_certificate_jks = hiera('manage_certificate_jks', true)
  $download_certificate   = hiera('manage_certificate_jks', false)
  $cert_download_url_base = "https://192.168.0.1/cert/"
  $keytool                = hiera('keytool', '/usr/bin/keytool')
  $host_cert_key          = hiera('host_cert_key', 'private.key')
  $host_cert_crt          = hiera('host_cert_crt', 'certificate.crt')
  $ca_cert                = hiera('ca_cert', 'ca_bundle.crt')
  $download_ca_cert       = "${cert_download_url_base}/${ca_cert}"
  $download_host_cert_key = "${cert_download_url_base}/${host_cert_key}"
  $download_host_cert_crt = "${cert_download_url_base}/${host_cert_crt}"
  $host_cert_pass         = hiera('host_cert_pass', '')
  $cert_alias             = hiera('cert_alias', 'sslforfree')
  $ca_cert_alias          = hiera('ca_cert_alias', 'ca_sslforfree')
  $keystore_pass_default  = 'changeit'
  #$keystore_pass          = hiera('keystore_pass', 'pass_cert')
  $keystore_pass          = "${keystore_pass_default}"
  $certs_dir              = '/etc/sslforfree'
  $keystore_file          = "${certs_dir}/keystore.jks"
  $cacerts_file           = "${certs_dir}/cacerts.jks"
}