class inithost::exec {
  
  if ( $::inithost::selinux_status in ['disabled', 'permissive'] and $::selinux_current_mode == 'enforcing' ) {
    exec { 'set_selinux_to_permissive':
      path    => $::inithost::base_cmd_path,
      command => "setenforce 0",
    }
  }

  if ( $::inithost::selinux_status == 'enforcing' ) {
    if ( $::selinux_current_mode == 'permissive' ) {
      exec { 'set_selinux_to_enforcing':
        path    => $::inithost::base_cmd_path,
        command => "setenforce 1",
      }
    } elsif ( $::selinux_current_mode == 'disabled' ) {
      notify { 'Can not set selinux to enforcing': 
        message => 'selinux status is disabled, set enforcing neet it is permissive',
      }
    }
  }
}
