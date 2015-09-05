class inithost::source {
  
  if ( $::inithost::base_source in ['present', 'absent'] ) {
    file { $::inithost::source_file:
      owner       => 0,
      group       => 0,
      mode        => '0644',
      ensure      => $::inithost::base_source,
      content     => template($::inithost::source_file_temp),
      backup      => ".$::backup_date",
    }
    exec { 'base-source-update':
      path        => $::inithost::base_cmd_path,
      command     => $::inithost::base_update_cmd,
      subscribe   => File[ $::inithost::source_file ],
      refreshonly => true,
      timeout     => 300,
    }

    if ($::inithost::source_epel_pkg) {
      package { $::inithost::source_epel_pkg:
        require     => Exec['base-source-update'],
        ensure      => $::inithost::base_source ? {
          "present"   => present,
          "absent"    => purged,
        },
      }

      file { $::inithost::source_epel_repo:
        owner       => 0,
        group       => 0,
        mode        => '0644',
        backup      => ".$::backup_date",
        ensure      => $::inithost::base_source,
        content     => template($::inithost::source_epel_temp)
      }

      exec { 'epel-source-update':
        path        => $::inithost::base_cmd_path,
        command     => $::inithost::base_update_cmd,
        subscribe   => File[ $::inithost::source_epel_repo ],
        refreshonly => true,
        timeout     => 300,
      }
    }
  }
}
