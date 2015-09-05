class inithost::params {
  
  $init_env       = '/etc/profile.d/bw-y-env.sh'
  $init_env_temp  = 'inithost/bw-y-env.sh.erb'
  $timezone_file  = '/etc/localtime'
  $timezone_src   = "/usr/share/zoneinfo"
  $ulimit_file    = '/etc/security/limits.conf'
  $ulimit_temp    = 'inithost/limits.conf.erb'
  $packages       = [ 'tree', 'tmux', 'iotop', 'mlocate', 'telnet', 'traceroute', 
    'ftp', 'lftp', 'wget', 'curl', 'elinks', 'iftop', 'openssl', 'ethtool', 'rsync',
    'rdate'
  ]
  case $::osfamily { 
    'Debian' : {
      $source_proxy_file     = '/etc/apt/apt.conf.d/02proxy'
      $source_proxy_temp     = 'inithost/ubuntu_proxy_conf.erb'
      $base_lang_file        = '/etc/default/locale'
      $base_lang_temp        = 'inithost/deb-lang.erb'
      $base_lang_varlib      = '/var/lib/locales/supported.d/local'
      $base_lang_varlib_tmp  = 'inithost/deb-lang-varlib.erb'
      $base_etc_timezone     = '/etc/timezone'
      $base_etc_rcs          = '/etc/default/rcS'
      $base_etc_rcs_temp     = 'inithost/deb-etc-rcS.erb'
      $base_lang_cmd         = '/usr/sbin/locale-gen'
      $ulimit_sh_file        = '/etc/profile.d/ulimit.sh'
      $ulimit_sh_temp        = 'inithost/ulimit.sh.erb'
      if $::operatingsystem == 'Ubuntu' { 
        $base_cmd_path       = '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games'
        $base_update_cmd     = 'apt-get update'
        $source_file         = '/etc/apt/sources.list'
        
        $public_pkgs         = [ 'command-not-found', 'locales', 'vim', 'ntpdate' ]
        if $::operatingsystemrelease == '12.04' {
          $source_file_temp  = 'inithost/ubt12.04-sources.list.erb'
          $base_pkgs         = flatten([$packages, $public_pkgs ])
        }
        if $::operatingsystemrelease == '14.04' {
          $source_file_temp  = 'inithost/ubt14.04-sources.list.erb'
          $base_pkgs         = flatten([$packages, $public_pkgs])
        }
      }
    }
    'RedHat' : {
      $base_update_cmd       = 'yum clean all && yum makecache'
      $base_lang_file        = '/etc/sysconfig/i18n'
      $base_lang_temp        = 'inithost/rpm-lang.erb'
      $base_lang_cmd         = '/usr/bin/locale'
      $selinux_file          = '/etc/selinux/config'
      $selinux_temp          = 'inithost/selinux.conf.erb'

      $source_proxy_file     = '/etc/yum.conf'
      $source_epel_pkg       = 'epel-release'
      $source_epel_repo      = '/etc/yum.repos.d/epel.repo'
      $source_file           = '/etc/yum.repos.d/bw-y-base.repo'

      $public_pkgs           = [ 'redhat-lsb', 'bash-completion', 'vim-enhanced', 
        'sysstat', 'bind-utils', 'man',
      ]

      if ( $::priosrelease == '5' ) {
        $base_cmd_path       = '/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin'
        $source_file_temp    = 'inithost/5-base.repo.erb'
        $source_epel_temp    = 'inithost/5-epel.repo.erb'
        $source_proxy_temp   = 'inithost/5-yum.conf.erb'
        $base_pkgs           = flatten([$packages, $public_pkgs])
      }
      if ( $::priosrelease == '6' ) {
        $source_proxy_temp   = 'inithost/6-yum.conf.erb'
        $source_file_temp    = 'inithost/6-base.repo.erb'
        $source_epel_temp    = 'inithost/6-epel.repo.erb'
        $private_pkgs        = [ 'ntpdate' ]
        $base_pkgs           = flatten([$packages, $public_pkgs, $private_pkgs])

        if $::operatingsystem == 'RedHat' {
          $base_cmd_path   = '/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin'
        }
        if $::operatingsystem == 'CentOS' {
          $base_cmd_path   = '/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin'
        }
      }
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
