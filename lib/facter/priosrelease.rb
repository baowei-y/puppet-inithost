Facter.add(:priosrelease) do
  confine :operatingsystem => %w{CentOS RedHat}
  setcode do
     %x{/usr/bin/facter operatingsystemrelease|awk -F. '{print $1}'}.chomp
  end
end
