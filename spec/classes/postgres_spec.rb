# frozen_string_literal: true

require 'spec_helper'

describe 'barman::postgres' do
  _, os_facts = on_supported_os.first

  let(:facts) do
    os_facts.merge(
      postgres_key: 'ssh-rsa AAABBB',
    )
  end

  let :pre_condition do
    <<~EOS
      include barman
      include postgresql::server
    EOS
  end

  context 'with default parameters' do
    let(:params) do
      {
        description: 'psql',
      }
    end
    it { is_expected.to compile.with_all_deps }

  end
end
