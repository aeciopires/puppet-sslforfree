# Class: check_space
#
# Parameters: none
#
# Actions:
#   Checa o espace requerido da particao /tmp
#   Check the required space of the partition / tmp
#
# Sample Usage:
#
#   include puppet_sslforfree::check_space
#
class puppet_sslforfree::check_space(

  #------------------------------------
  # ATENCAO! As variaveis referenciadas sao usadas neste manifest e/ou nos
  #   arquivos de templates.
  # ATTENTION! How referenced variables are used in this document and / or
  #   template files.
  #------------------------------------

  #Variaveis gerais
  $tmp_dir        = $puppet_sslforfree::params::tmp_dir,
  $space_required = $puppet_sslforfree::params::space_required,

  ) inherits puppet_sslforfree::params {

  # Alguns sysadmins criam o /tmp em particao separada do /
  if $::mountpoints["${tmp_dir}"] {
    $free_space = $::mountpoints["${tmp_dir}"]['available_bytes']
  }
  # Se entrar no elsif, eh porque o /tmp esta na mesma particao do /
  elsif $::mountpoints['/'] {
    $free_space = $::mountpoints['/']['available_bytes']
  }

  #Testando se ha o espaco requerido
  if $free_space > $space_required {
    notify{ 'info_free_space_disk':
      message => "[OK] There is sufficient free space in ${tmp_dir}. Space \
        required: ${space_required} bytes, free space: ${free_space} bytes",
    }
  }
  else {
    fail("[ERROR] Insufficient space in partition ${tmp_dir}. Space required: \
      ${space_required} bytes, free space: ${free_space} bytes")
  }
}
