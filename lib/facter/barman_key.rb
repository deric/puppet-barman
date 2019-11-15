# frozen_string_literal: true

require 'etc'

def barman_safe_keygen_and_return(user)
  Etc.passwd do |entry|
    if entry.name == user
      if File.exist? "#{entry.dir}/.ssh/id_rsa.pub"
        return File.read("#{entry.dir}/.ssh/id_rsa.pub").chomp
      else
        Facter::Util::Resolution.exec("su - #{entry.name} -c \"ssh-keygen -t rsa -P '' -q -f #{entry.dir}/.ssh/id_rsa\"")
        if File.exist? "#{entry.dir}/.ssh/id_rsa.pub"
          return File.read("#{entry.dir}/.ssh/id_rsa.pub").chomp
        else
          return ''
        end
      end
    end
  end
  ''
end

Facter.add('barman_key') do
  confine kernel: 'Linux'
  setcode do
    barman_safe_keygen_and_return('barman')
  end
end

Facter.add('postgres_key') do
  confine kernel: 'Linux'
  setcode do
    barman_safe_keygen_and_return('postgres')
  end
end
