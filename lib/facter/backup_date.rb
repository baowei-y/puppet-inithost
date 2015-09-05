# backup_date.rb
#
Facter.add("backup_date") do
  setcode do
    Time.now.strftime("%Y%m%d-%H%M_%s")
  end
end
