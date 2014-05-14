require 'spec_helper'

describe 'slurm::install' do
  let(:facts) { default_facts }

  let(:pre_condition) { "class { 'slurm': }" }

  it { should create_class('slurm::install') }
  it { should contain_class('slurm') }

  package_runtime_dependencies = [
    'hwloc',
    'numactl',
    'libibmad',
    'freeipmi',
    'rrdtool',
    'gtk2',
  ]

  package_runtime_dependencies.each do |p|
    it { should contain_package(p).with_ensure('present') }
  end

  it { should have_package_resource_count(9) }

  it { should contain_package('slurm').with_ensure('present').without_require }
  it { should contain_package('slurm-munge').with_ensure('present').without_require }
  it { should contain_package('slurm-plugins').with_ensure('present').without_require }

  it { should_not contain_package('slurm-devel') }
  it { should_not contain_package('slurm-pam_slurm') }

  context 'when ensure => "2.6.9"' do
    let(:params) {{ :ensure => '2.6.9-1.el6' }}

    it { should contain_package('slurm').with_ensure('2.6.9-1.el6') }
    it { should contain_package('slurm-munge').with_ensure('2.6.9-1.el6') }
    it { should contain_package('slurm-plugins').with_ensure('2.6.9-1.el6') }
  end

  context 'when package_require => "Yumrepo[local]"' do
    let(:params) {{ :package_require => "Yumrepo[local]" }}

    it { should contain_package('slurm').with_require('Yumrepo[local]') }
    it { should contain_package('slurm-munge').with_require('Yumrepo[local]') }
    it { should contain_package('slurm-plugins').with_require('Yumrepo[local]') }
  end

  context 'when use_pam => true' do
    let(:params) {{ :use_pam => true }}
    it { should contain_package('slurm-pam_slurm').with_ensure('present') }
  end

  context 'when with_devel => true' do
    let(:params) {{ :with_devel => true }}
    it { should contain_package('slurm-devel').with_ensure('present') }
  end
end