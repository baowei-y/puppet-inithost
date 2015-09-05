#
class inithost (
  # Base
  $base_lang           = '',
  $base_timezone       = 'Asia/Shanghai',
  $base_package        = false,
  $base_source         = 'ignore',
  $source_url          = 'mirrors.aliyun.com',
  $source_proxy        = '',
  $selinux_status      = 'disabled',
  $superuser_ensure    = 'absent',
  $superuser_name      = 'xx00',
  $superuser_pass      = '$6$PHKSLyZj$8/fdMec3l3TpWpfQM.ji4h5P2wnUv9o.rIC8vHOyNeCR9Qrab6Cbmoaq1qtFiogGofNKlwWTaj1I48j1isF7m/',
  $init_env_ensure     = 'present',
  $ulimit_nofile       = "1048576",
  $ulimit_noproc       = "1048576",
) inherits ::inithost::params {

#
# check.... 
#

  anchor { 'inithost::begin': } ->
  class { '::inithost::files': } ->
  class { '::inithost::oslang': } ->
  class { '::inithost::exec': } ->
  class { '::inithost::source': } ->
  class { '::inithost::packages': } ->
  class { '::inithost::superuser': } ->
  anchor { 'inithost::end': }
}
