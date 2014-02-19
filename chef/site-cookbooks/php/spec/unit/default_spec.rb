# encoding: UTF-8

require 'chefspec'

describe 'php::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs php package' do
    expect(chef_run).to install_package('php')
  end

  it 'installs php-mysql package' do
    expect(chef_run).to install_package('php-mysql')
  end

#  it 'installs php-cli package' do
#    expect(chef_run).to install_package('php-cli')
#  end
end
