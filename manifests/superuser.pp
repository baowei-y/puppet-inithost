class inithost::superuser {
  
  user { $::inithost::superuser_name:
    ensure => "$::inithost::superuser_ensure",
    home => "/home/$::inithost::superuser_name",
    shell => "/bin/bash",
    managehome => true,
    password => "$::inithost::superuser_pass"
  }

  if ( $::inithost::superuser_ensure == 'present' ) {
    augeas { "add sudo for $::inithost::superuser_name":
      context => '/files/etc/sudoers',
      changes => [
        "set spec[user = '$::inithost::superuser_name']/user \"$::inithost::superuser_name\"",
        "set spec[user = '$::inithost::superuser_name']/host_group/host \"ALL\"",
        "set spec[user = '$::inithost::superuser_name']/host_group/command \"ALL\"",
        "set spec[user = '$::inithost::superuser_name']/host_group/command/runas_user \"ALL\"",
        "set spec[user = '$::inithost::superuser_name']/host_group/command/tag \"NOPASSWD\"",
        "set Defaults[type=':$::inithost::superuser_name']/type :$::inithost::superuser_name",
        "set Defaults[type=':$::inithost::superuser_name']/requiretty/negate \"\"",
      ],
    }
  }
}
