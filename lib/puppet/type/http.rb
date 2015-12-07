Puppet::Type.newtype :http, :is_capability => true do
  newparam :name, :namevar => true
  newparam :host
  newparam :port
end
