Puppet::Type.newtype :citiesapi, :is_capability => true do
  newparam :name, :namevar => true
  newparam :cahost
  newparam :ip
end
