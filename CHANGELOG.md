## 2023-12-15 - Release 4.1.0

**Bugfixes**
-  Allow dashes Barman::ServerName type [#5](https://github.com/deric/puppet-barman/pull/5)
-  `barman_incoming_dir` expects a String [#8](https://github.com/deric/puppet-barman/pull/8)
- Add missing parameter `hba_entry_order` [#9](https://github.com/deric/puppet-barman/pull/9)

**Changes**
- Added acceptance tests [#7](https://github.com/deric/puppet-barman/pull/7)
- Removed Debian 8 and Debian 9 support
- Added Debian 11 and 12
- `barman_incoming_dir` defaults to `undef` instead of an empty string

**Features**
- Compatible with `puppetlabs/stdlib` 9
- Compatible with `puppetlabs/postgresql` 10
- Add `barman_lock_directory` [#6](https://github.com/deric/puppet-barman/pull/6)
- Allow setting archive mode to always [#10](https://github.com/deric/puppet-barman/pull/10)

- [Full changes](https://github.com/deric/puppet-barman/compare/v4.0.0...v4.1.0)


## 2023-08-09 - Release 4.0.0

- Puppet 8 support
- Puppet types validation
- Compatible with `puppetlabs/stdlib` 8
- Removed `barman::settings` class
- [Full changes](https://github.com/deric/puppet-barman/compare/v3.0.0...v4.0.0)


## 2021-08-09 - Release 3.0.0

- BC: Changed ssh key name from `barman` to `postgres-${fqdn}` in order to support multiple barman servers
- `archive_command` might use `rsync` or `barman-wal-archive`
- add --wait to barman backup cronjob
- Puppet 6 support and drop Puppet 5 support
- Drop deprecated Linux distributions
- Bump minimum and maximum module version requirements
- Keep only required `facts` in unit tests
- Unit tests performance improvement by making `puppetversion` fact to run only once
- Changed config directory from `/etc/barman.conf.d` to `/etc/barman.d`

## 2019-11-18 - Release 2.2.0

### Summary

- Forked from [2ndquadrant-it/puppet-barman](https://github.com/2ndquadrant-it/puppet-barman), released as `deric-barman`. A bugfix release.
- Allow modifying hba order
- Allow more recent dependent modules
- Use `postgres_server_id` as unique identifier (cron, SSH key, authorized key)
- Add parameter `cron_user` to customize to which crontab jobs are added.

#### Bugfixes

- `backup_directory` is twice in template file (2ndquadrant-it/puppet-barman#50)
- Configurable barman home directory permissions (2ndquadrant-it/puppet-barman#52)
- Enable `quiet mode` in ssh connection (2ndquadrant-it/puppet-barman#51)
- Disable archive mode when archiver is disabled (2ndquadrant-it/puppet-barman#56)

## 2018-01-09 - Release 2.1.0

### Summary

- Improved hiera support
- Added support for `backup_directory`, `log_level` and `parallel_cron_jobs`
- Added support for SSH host key exchange
- Updated module dependencies to need newer postgresql and apt modules

#### Bugfixes

- #38, #48 Make pg_hba_rule title server-specific to avoid duplication
- Added settings that were left behind to the template
- Only set `archive_command` if archiving is enabled
- Avoid exchanging ssh authentication keys if the setup is streaming only

## 2017-03-16 - Release 2.0.2

### Summary

Add support for recovery_options setting

## 2017-02-06 - Release 2.0.1

### Summary
Fixed a couple outstanding bugs.
Thanks to mzsamantha and James Miller.

#### Bugfixes

- streaming_conninfo missing from server template
- allow _ in server names

## 2017-01-11 - Release 2.0.0

### Summary

Module update to support barman 2.x (thanks to Leo Antunes)

This release may break compatibility with puppet < 4

## 2015-03-24 - Release 1.0.0

### Summary

Major improvements in autoconfiguration module.

This release changes the default value of `manage_package_repo`
parameter to `false`.

#### Features
- Improved autoconfiguration module
- Improved documentation
- Enabled test suit again
- Enabled Travis CI

#### Bugfixes
- #24 postgresql_server_id is not used consistently
- #25 Allow configuring $retention_policy in barman::postgres
- #26 postgres::globals shouldnt be defined in barman
