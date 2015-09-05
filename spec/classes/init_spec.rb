require 'spec_helper'
describe 'inithost' do

  context 'with defaults for all parameters' do
    it { should contain_class('inithost') }
  end
end
