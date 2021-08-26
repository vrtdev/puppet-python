require 'spec_helper'

describe 'requirements' do
  it 'checks declared requirements file is installed to venv' do
    pp = <<-EOS
    class {'/tmp/requirements.txt':
      ensure => 'present',
      content => 'requests'
    }

    python::venv {'/tmp/pyvenv':
      ensure => 'present',
      version => ${facts['python_version']}
    }

    python::requirements {'/tmp/requirements.txt':
      virtualenv => '/tmp/pyvenv'
    }
    EOS

    apply_manifest(pp, catch_failures: true)

    expect(shell('/bin/pip3 list --no-index | grep requests'.stdout).to match(%r{requests: \(\d+.\d+.\d+\)}))
  end
end
