class inithost::oslang {
  
  if ( $::inithost::base_lang ) {
    file { $::inithost::base_lang_file:
      owner   => 0,
      group   => 0,
      mode    => '0644',
      content => template($::inithost::base_lang_temp),
      backup  => ".$::backup_date",
    }
  
    if ( $::inithost::base_lang_varlib ) {
      file { $::inithost::base_lang_varlib:
        owner   => 0,
        group   => 0,
        mode    => '0644',
        content => template($::inithost::base_lang_varlib_tmp),
        backup  => ".$::backup_date",
      }
      exec { 'reload-os-lang':
        refreshonly => true,
        path        => $::inithost::base_cmd_path,
        command     => $::inithost::base_lang_cmd,
        require     => File [ 
          "$::inithost::base_lang_varlib", 
          "$::inithost::base_lang_file"
        ],
        subscribe   => File [ 
          "$::inithost::base_lang_varlib", 
          "$::inithost::base_lang_file" 
        ],
      }
    }
  }
}
