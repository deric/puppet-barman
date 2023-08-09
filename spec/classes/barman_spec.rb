# frozen_string_literal: true

require 'spec_helper'

describe 'barman' do
  _, os_facts = on_supported_os.first
  let(:facts) { os_facts }

  it { is_expected.to compile.with_all_deps }
  # Installs barman
  it { is_expected.to contain_package('barman').with_tag('postgresql') }

  # Creates the configurations
  it { is_expected.to contain_file('/etc/barman.d').with_ensure('directory') }
  it { is_expected.to contain_file('/etc/logrotate.d/barman') }

  context 'with default conf_file_path' do
    let(:params) do
      {
        conf_file_path: '/etc/barman/barman.conf'
      }
    end

    it { is_expected.to contain_file('/etc/barman').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/barman/barman.conf').with_content(%r{\[barman\]}) }
    it { is_expected.to contain_file('/etc/barman/barman.conf').with_content(%r{compression = gzip}) }
    it { is_expected.not_to contain_file('/etc/barman.conf').with_content(%r{_backup_script}) }
  end

  context 'with conf_file_path override' do
    let(:params) do
      {
        conf_file_path: '/etc/barman.conf'
      }
    end

    it { is_expected.not_to contain_file('/etc/barman').with_ensure('directory') }
    it { is_expected.to contain_file('/etc/barman.conf').with_content(%r{\[barman\]}) }
    it { is_expected.to contain_file('/etc/barman.conf').with_content(%r{compression = gzip}) }
    it { is_expected.not_to contain_file('/etc/barman.conf').with_content(%r{_backup_script}) }
  end

  # Creates barman home and launches 'barman check all'
  it { is_expected.to contain_file('/var/lib/barman') }
  it { is_expected.to contain_exec('barman-check-all') }

  context 'with autoconfigure' do
    let(:params) do
      {
        autoconfigure: true,
        barman_fqdn: 'test',
      }
    end
    let(:facts) do
      super().merge(
        { 'barman_key' => 'ssh-rsa AAABBB' },
      )
    end

    it {
      expect(exported_resources).to contain_ssh_authorized_key('postgres-test').with(
        user: 'postgres',
        type: 'ssh-rsa',
        key: 'AAABBB',
      )
    }

    it {
      expect(exported_resources).to contain_barman__archive_command('test').with(
        archive_cmd_type: 'rsync',
        barman_home: '/var/lib/barman',
      )
    }

    it {
      is_expected.to contain_file('/var/lib/barman/.pgpass')
        .with({
                'ensure' => 'file',
              })
    }

    context 'with barman wal archive command' do
      let(:params) do
        {
          autoconfigure: true,
          archive_cmd_type: 'barman-wal-archive',
          barman_fqdn: 'wal-test',
        }
      end

      it {
        expect(exported_resources).to contain_barman__archive_command('wal-test').with(
          archive_cmd_type: 'barman-wal-archive',
          barman_home: '/var/lib/barman',
        )
      }
    end
  end

  # Creates the new home and launches barman check all
  context 'with different home' do
    let(:params) do
      {
        home: '/srv/barman',
      }
    end

    it { is_expected.to contain_file('/srv/barman').with_ensure('directory') }
    it { is_expected.to contain_exec('barman-check-all') }
  end

  context 'when managing ssh host keys' do
    let(:params) do
      {
        manage_ssh_host_keys: true,
      }
    end

    it { is_expected.to contain_file('/var/lib/barman/.ssh').with_ensure('directory') }
    it { is_expected.to contain_file('/var/lib/barman/.ssh/known_hosts') }
  end

  # Rotates the right log when supplied
  context 'with different log' do
    let(:params) do
      {
        logfile: '/tmp/foo',
      }
    end

    it { is_expected.to contain_file('/etc/logrotate.d/barman').with_content(%r{^/tmp/foo }) }
  end

  # Writes the right parameters in the compiled template
  context 'with different parameters' do
    let(:params) do
      {
        compression: false,
        pre_backup_script: '/bin/false',
        post_backup_script: '/bin/false',
        custom_lines: 'thisisastring',
      }
    end

    it { is_expected.not_to contain_file('/etc/barman/barman.conf').with_content(%r{compression}) }
    it { is_expected.to contain_file('/etc/barman/barman.conf').with_content(%r{pre_backup_script = /bin/false}) }
    it { is_expected.to contain_file('/etc/barman/barman.conf').with_content(%r{post_backup_script = /bin/false}) }
    it { is_expected.to contain_file('/etc/barman/barman.conf').with_content(%r{thisisastring}) }
  end

  # Test interaction between manage_package_repo parameter and postgresql::global
  context 'with postgresql::globals already defined' do
    let :pre_condition do
      <<-HERE
        class {'postgresql::globals':
          manage_package_repo => true,
        }
      HERE
    end

    context 'with manage_package_repo => true' do
      let(:params) do
        {
          manage_package_repo: true,
        }
      end

      it { is_expected.to raise_error(Puppet::Error, %r{postgresql::globals is already defined}) }
    end

    context 'with manage_package_repo => false' do
      let(:params) do
        {
          manage_package_repo: false,
        }
      end

      it { is_expected.to compile }
    end
  end
end
