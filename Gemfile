source ENV['GEM_SOURCE'] || "https://rubygems.org"

group :development, :unit_tests do
  gem 'iconv',                  :require => false
  gem 'metadata-json-lint',     :require => false
  gem 'parallel_tests',         :require => false
  gem 'puppet_facts',           :require => false
  gem 'puppet-lint',            :require => false
  gem 'puppetlabs_spec_helper', :require => false
  gem 'rake',                   :require => false
  gem 'rspec-core',             :require => false
  gem 'rspec-puppet',           :require => false
  gem 'rubocop-i18n',           :require => false
  gem 'rubocop-rspec',          :require => false
  gem 'rubocop',                :require => false
  gem 'simplecov',              :require => false
  gem 'librarian-puppet', '>= 3.0'
end

group :development do
  gem 'puppet-blacksmith'
  gem 'pdk', '>= 1.0'
end

group :system_tests do
  gem 'beaker-rspec',  :require => false
  gem 'serverspec',    :require => false
end

if facterversion = ENV['FACTER_GEM_VERSION']
  gem 'facter', facterversion, :require => false
else
  gem 'facter', :require => false
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

# vim:ft=ruby
