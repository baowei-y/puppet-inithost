class inithost::files {

  augeas { 'add_127_to_localhosts':
    context => "/files/etc/hosts",
    changes => [
      "ins 02 after 1",
      "set 02/ipaddr 127.0.0.1",
      "set 02/canonical localhost",
    ],
    onlyif  => "match *[ipaddr='127.0.0.1'][canonical='localhost'] size == 0"
  }

  file { $::inithost::init_env:
    ensure  => $::inithost::init_env_ensure,
    content => template($::inithost::init_env_temp),
    owner   => 0,
    group   => 0,
    mode    => '0644',
    backup  => ".$::backup_date",
  }

  file { $::inithost::ulimit_file:
    content => template($::inithost::ulimit_temp),
    owner   => 0,
    group   => 0,
    mode    => '0644',
    backup  => ".$::backup_date",
  }
  
  if ( $::inithost::ulimit_sh_file ) {
    file { $::inithost::ulimit_sh_file:
      content => template($::inithost::ulimit_sh_temp),
      owner   => 0,
      group   => 0,
      mode    => '0644',
      backup  => ".$::backup_date",
    }
  }

  file { $::inithost::timezone_file:
    ensure  => link,
    target  => "${::inithost::timezone_src}/${::inithost::base_timezone}",
    backup  => ".$::backup_date",
  }
  
  if ( $::inithost::base_etc_timezone ){
    file { $::inithost::base_etc_timezone:
      content => "${::inithost::base_timezone}",
      owner   => 0,
      group   => 0,
      mode    => '0644',
      backup  => ".$::backup_date",
    }
  }
  
  if ( $::inithost::base_etc_rcs ){
    file { $::inithost::base_etc_rcs:
      content => template($::inithost::base_etc_rcs_temp),
      owner   => 0,
      group   => 0,
      mode    => '0644',
      backup  => ".$::backup_date",
    }
  }
  
  file { $::inithost::source_proxy_file:
    owner   => 0,
    group   => 0,
    mode    => '0644',
    content => template($::inithost::source_proxy_temp),
  }
  
  if ( $::inithost::selinux_file ) {
    file { $::inithost::selinux_file:
      owner   => 0,
      group   => 0,
      mode    => '0644',
      content => template($::inithost::selinux_temp),
      backup  => ".$::backup_date",
    }
  }
}
