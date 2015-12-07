Puppet::Type.newtype :db, :is_capability => true do
  newparam :name, :namevar => true
  newparam :dbname
  newparam :dbhost
  newparam :dbpass
  newparam :dbuser
end
