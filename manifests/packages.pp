class inithost::packages {
  
  if ($::inithost::base_package) {
    package { $::inithost::base_pkgs:
      ensure => present,
    }
  }

}
