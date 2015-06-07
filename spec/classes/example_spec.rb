require 'spec_helper'

describe 'bmcremote' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "bmcremote class without any parameters" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('bmcremote::params') }
          it { is_expected.to contain_class('bmcremote::install').that_comes_before('bmcremote::config') }
          it { is_expected.to contain_class('bmcremote::config') }
          it { is_expected.to contain_class('bmcremote::service').that_subscribes_to('bmcremote::config') }

          it { is_expected.to contain_service('bmcremote') }
          it { is_expected.to contain_package('bmcremote').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'bmcremote class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('bmcremote') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
