Puppet::Type.newtype :infoapi, :is_capability => true do
  newparam :name, :namevar => true
  newparam :iahost
  newparam :ip
end
