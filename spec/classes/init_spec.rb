require 'spec_helper'
describe 'worldofcontainers' do

  context 'with defaults for all parameters' do
    it { should contain_class('worldofcontainers') }
  end
end
