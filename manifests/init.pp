# @summary This class installs Barman (Backup and recovery manager for Postgres).
#
# === Facts
#
# The module generates a fact called '*barman_key*' which has the content of
#  _/var/lib/barman/.ssh/id_rsa.pub_, in order to automatically handle the
#  key exchange on the postgres server via puppetdb.
# If the file doesn't exist, a key will be generated.

# @example The class can be used right away with defaults:
#
#  include barman
#
# @example All parameters that are supported by barman can be changed:
#  class { barman:
#    logfile  => '/var/log/barman/something_else.log',
#    compression => 'bzip2',
#    pre_backup_script => '/usr/bin/touch /tmp/started',
#    post_backup_script => '/usr/bin/touch /tmp/stopped',
#    custom_lines => '; something'
#  }
#
# === Authors
#
# * Giuseppe Broccolo <giuseppe.broccolo@2ndQuadrant.it>
# * Giulio Calacoci <giulio.calacoci@2ndQuadrant.it>
# * Francesco Canovai <francesco.canovai@2ndQuadrant.it>
# * Marco Nenciarini <marco.nenciarini@2ndQuadrant.it>
# * Gabriele Bartolini <gabriele.bartolini@2ndQuadrant.it>
# * Alessandro Grassi <alessandro.grassi@2ndQuadrant.it>
#
# Many thanks to Alessandro Franceschi <al@lab42.it>
#
# === Copyright
#
# Copyright 2012-2017 2ndQuadrant Italia
#
# @param user
#   The Barman user. Default `barman`.
# @param group
#   The group of the Barman user
# @param ensure
#   Ensure that Barman is installed. The default value is 'present'.
#   Otherwise it will be set as 'absent'.
# @param dbuser
#   Username used for connecting to the database
# @param dbname
# @param conf_file_path
#   Absolute path to main `barman.conf` file
# @param conf_template
#   Path of the template of the barman.conf configuration
#    file. The default value does not need to be changed.
# @param logrotate_template
#   Path of the template of the logrotate.conf file.
#   The default value does not need to be changed.
# @param home
#   A different place for backups than the default. Will be symlinked
#   to the default (/var/lib/barman). You should not change this
#     value after the first setup.
# @param home_mode
#   Directory mode, default: `0750`
# @param logfile
#   A different log file. The default is '/var/log/barman/barman.log'
# @param log_level
#   Level of logging. The default is INFO
#   (DEBUG, INFO, WARNING, ERROR, CRITICAL). Global.
# @param archiver
#   Whether the log shipping backup mechanism is active or not (defaults to true)
# @param archive_cmd_type
#   Default `rsync`
# @param hba_entry_order
#  Entry priority
# @param archiver_batch_size
#   Setting this option enables batch processing of WAL files.
#   The default processes all currently available files.
# @param backup_method
#   Configure the method barman used for backup execution. If set to rsync (default),
#   barman will execute backup using the rsync command. If set to postgres barman will use the
#   pg_basebackup command to execute the backup.
# @param backup_options
#   Behavior for backup operations: possible values are exclusive_backup (default) and concurrent_backup.
# @param recovery_options
#   The restore command to write in the recovery.conf.
#   Possible values are 'get-wal' and undef. Default: undef.
# @param bandwidth_limit
#   This option allows you to specify a maximum transfer rate in kilobytes per second.
#   A value of zero specifies no limit (default).
# @param barman_lock_directory
#   Global option for a directory for lock files.
# @param check_timeout
#  Maximum execution time, in seconds per server, for a barman
#  check command. Set to 0 to disable the timeout. Positive integer, default 30.
# @param compression
#   Compression algorithm. Currently supports 'gzip' (default),
#   'bzip2', and 'custom'. Disabled if false.
# @param create_slot
#  Determines whether Barman should automatically create a replication slot if it’s
#  not already present for streaming WAL files. One of 'auto' or 'manual' (default).
# @param custom_compression_filter
#   Customised compression algorithm applied to WAL files.
# @param custom_decompression_filter
#   Customised decompression algorithm applied to compressed WAL files; this must match the
#   compression algorithm.
# @param immediate_checkpoint
#   Force the checkpoint on the Postgres server to happen immediately and start your backup copy
#   process as soon as possible. Disabled if false (default)
# @param basebackup_retry_times
#   Number of retries fo data copy during base backup after an error. Default = 0
# @param basebackup_retry_sleep
#   Number of seconds to wait after after a failed copy, before retrying. Default = 30
# @param minimum_redundancy
#   Minimum number of required backups (redundancy). Default = 0
# @param network_compression
# This option allows you to enable data compression for network transfers. Defaults to false.
# @param parallel_jobs
#  Number of parallel workers used to copy files during backup or recovery. Requires backup mode = rsync.
# @param path_prefix
# One or more absolute paths, separated by colon, where Barman
#                   looks for executable files.
# @param last_backup_maximum_age
# Time frame that must contain the latest backup
#                               date. If the latest backup is older than the
#                               time frame, barman check command will report an
#                               error to the user. Empty if false (default).
# @param post_archive_retry_script
# Hook script launched after a WAL file is
#                                 archived by maintenance. Being this a retry hook
#                                 script, Barman will retry the execution of the
#                                 script until this either returns a SUCCESS (0),
#                                 an ABORT_CONTINUE (62) or an ABORT_STOP (63)
#                                 code. In a post archive scenario, ABORT_STOP has
#                                 currently the same effects as ABORT_CONTINUE.
# @param post_archive_script
# Hook script launched after a WAL file is archived by
#                           maintenance, after 'post_archive_retry_script'.
# @param post_backup_retry_script
# Hook script launched after a base backup. Being
#                                this a retry hook script, Barman will retry the
#                                execution of the script until this either returns
#                                a SUCCESS (0), an ABORT_CONTINUE (62) or an
#                                ABORT_STOP (63) code. In a post backup scenario,
#                                ABORT_STOP has currently the same effects as
#                                ABORT_CONTINUE.
# @param post_backup_script
# Hook script launched after a base backup, after
#                          'post_backup_retry_script'.
# @param pre_archive_retry_script
# Hook script launched before a WAL file is
#                                archived by maintenance, after
#                                'pre_archive_script'. Being this a retry hook
#                                script, Barman will retry the execution of the
#                                script until this either returns a SUCCESS (0),
#                                an ABORT_CONTINUE (62) or an ABORT_STOP (63)
#                                code. Returning ABORT_STOP will propagate the
#                                failure at a higher level and interrupt the WAL
#                                archiving operation.
# @param pre_archive_script
# Hook script launched before a WAL file is archived by
# 			   maintenance.
# @param pre_backup_retry_script
# Hook script launched before a base backup, after
#                               'pre_backup_script'. Being this a retry hook
#                               script, Barman will retry the execution of the
#                               script until this either returns a SUCCESS (0), an
#                               ABORT_CONTINUE (62) or an ABORT_STOP (63) code.
#                               Returning ABORT_STOP will propagate the failure at
#                               a higher level and interrupt the backup operation.
# @param pre_backup_script
# Hook script launched before a base backup.
# @param retention_policy
# Base backup retention policy, based on redundancy or
#                        recovery window. Default empty (no retention enforced).
#                        Value must be greater than or equal to the server
#                        minimum redundancy level (if not is is assigned to
#                        that value and a warning is generated).
# @param wal_retention_policy
# WAL archive logs retention policy. Currently, the
#                            only allowed value for wal_retention_policy is the
#                            special value main, that maps the retention policy
#                            of archive logs to that of base backups.
# @param retention_policy_mode
# Can only be set to auto (retention policies are
#                             automatically enforced by the barman cron command)
# @param reuse_backup
# Incremental backup is a kind of full periodic backup which
#                    saves only data changes from the latest full backup
#                    available in the catalogue for a specific PostgreSQL
#                    server. Disabled if false. Default false.
# @param slot_name
# Physical replication slot to be used by the receive-wal
#                 command when streaming_archiver is set to on. Requires
#                 postgreSQL >= 9.4. Default: undef (disabled).
# @param streaming_archiver
# This option allows you to use the PostgreSQL's
#                          streaming protocol to receive transaction logs from a
#                          server. This activates connection checks as well as
#                          management (including compression) of WAL files. If
#                          set to off (default) barman will rely only on
#                          continuous archiving for a server WAL archive
#                          operations, eventually terminating any running
#                          pg_receivexlog for the server.
# @param streaming_archiver_batch_size
# This option allows you to activate batch
#                                     processing of WAL files for the
#                                     streaming_archiver process, by setting it to
#                                     a value > 0. Otherwise, the traditional
#                                     unlimited processing of the WAL queue is
#                                     enabled.
# @param streaming_archiver_name
# Identifier to be used as application_name by the
#                               receive-wal command. Only available with
#                               pg_receivexlog >= 9.3. By default it is set to
#                               barman_receive_wal.
# @param streaming_backup_name
# Identifier to be used as application_name by the
#                             pg_basebackup command. Only available with
#                             pg_basebackup >= 9.3. By default it is set to
#                             barman_streaming_backup.
# @param streaming_wals_directory
# Directory where WAL files are streamed from the
#                                PostgreSQL server to Barman.
# @param tablespace_bandwidth_limit
# This option allows you to specify a maximum
#                                  transfer rate in kilobytes per second, by
#                                  specifying a comma separated list of
#                                  tablespaces (pairs TBNAME:BWLIMIT). A value of
#                                  zero specifies no limit (default).
# @param custom_lines
# DEPRECATED. Custom configuration directives (e.g. for
#                    custom compression). Defaults to empty.
# @param barman_fqdn
# The fqdn of the Barman server. It will be exported in
#                   several resources in the PostgreSQL server. Puppet
#                   automatically set this.
# @param autoconfigure
# This is the main parameter to enable the
#                     autoconfiguration of the backup of a given PostgreSQL
#                     server. Defaults to false.
# @param exported_ipaddress
# The ipaddress exported to the PostgreSQL server
#                          during atutoconfiguration. Defaults to
#                          "${::ipaddress}/32".
# @param host_group
#  Tag used to collect and export resources during
#                   autoconfiguration. Defaults to 'global'.
# @param manage_package_repo
# Configure PGDG repository. It is implemented
#                           internally by declaring the `postgresql::globals`
#                           class. If you need to customize the
#                           `postgresql::globals` class declaration, keep the
#                           `manage_package_repo` parameter disabled in `barman`
#                           module and enable it directly in
#                           `postgresql::globals` class.
# @param manage_ssh_host_keys
# When using autoconfigure, ensure the hosts contain
#                            each other ssh host key. Must also be set on
#                            'barman::postgres' class. Defaults to false.
# @param purge_unknown_conf
# Whether or not barman conf files not included in
#                          puppetdb will be removed by puppet.
# @param servers
# hiera hash to support the server define.
#               Defaults to undef.
#
class barman (
  String                             $user,
  String                             $group,
  String                             $ensure,
  Boolean                            $archiver,
  Boolean                            $autoconfigure,
  Variant[String,Boolean]            $compression,
  String                             $dbuser,
  Stdlib::Absolutepath               $home,
  String                             $home_mode,
  String                             $host_group,
  String                             $dbname,
  Boolean                            $immediate_checkpoint,
  Stdlib::Absolutepath               $logfile,
  Barman::LogLevel                   $log_level,
  Boolean                            $manage_package_repo,
  Boolean                            $manage_ssh_host_keys,
  Integer                            $minimum_redundancy,
  Boolean                            $purge_unknown_conf,
  Boolean                            $streaming_archiver,
  String                             $archive_cmd_type,
  Integer                            $hba_entry_order,
  String                             $conf_file_path                = $barman::conf_file_path,
  String                             $conf_template                 = 'barman/barman.conf.erb',
  String                             $logrotate_template            = 'barman/logrotate.conf.erb',
  String                             $barman_fqdn                   = $facts['networking']['fqdn'],
  Optional[Integer]                  $archiver_batch_size           = undef,
  Barman::BackupMethod               $backup_method                 = undef,
  Barman::BackupOptions              $backup_options                = undef,
  Optional[Integer]                  $bandwidth_limit               = undef,
  Optional[String]                   $barman_lock_directory         = undef,
  Optional[Integer]                  $basebackup_retry_sleep        = undef,
  Optional[Integer]                  $basebackup_retry_times        = undef,
  Optional[Integer]                  $check_timeout                 = undef,
  Barman::CreateSlot                 $create_slot                   = undef,
  Optional[String]                   $custom_compression_filter     = undef,
  Optional[String]                   $custom_decompression_filter   = undef,
  Stdlib::IP::Address                $exported_ipaddress            = "${facts['networking']['ip']}/32",
  Barman::BackupAge                  $last_backup_maximum_age        = undef,
  Optional[Boolean]                  $network_compression            = undef,
  Optional[Integer]                  $parallel_jobs                  = undef,
  Optional[Stdlib::Absolutepath]     $path_prefix                    = undef,
  Optional[String]                   $post_archive_retry_script      = undef,
  Optional[String]                   $post_archive_script            = undef,
  Optional[String]                   $post_backup_retry_script       = undef,
  Optional[String]                   $post_backup_script             = undef,
  Optional[String]                   $pre_archive_retry_script       = undef,
  Optional[String]                   $pre_archive_script             = undef,
  Optional[String]                   $pre_backup_retry_script        = undef,
  Optional[String]                   $pre_backup_script              = undef,
  Barman::RecoveryOptions            $recovery_options               = undef,
  Barman::RetentionPolicy            $retention_policy               = undef,
  Barman::RetentionPolicyMode        $retention_policy_mode          = undef,
  Barman::ReuseBackup                $reuse_backup                   = undef,
  Optional[String]                   $slot_name                      = undef,
  Optional[Integer]                  $streaming_archiver_batch_size  = undef,
  Optional[String]                   $streaming_archiver_name        = undef,
  Optional[String]                   $streaming_backup_name          = undef,
  Optional[String]                   $tablespace_bandwidth_limit     = undef,
  Barman::WalRetention               $wal_retention_policy           = undef,
  Optional[String]                   $custom_lines                   = undef,
  Optional[Hash]                     $servers                        = undef,
  Optional[Stdlib::Absolutepath]     $streaming_wals_directory       = undef,
) {
  # when hash data is in servers, then fire-off barman::server define with that hash data
  if ($servers) {
    create_resources('barman::server', deep_merge(hiera_hash('barman::servers', {}), $servers))
  }

  # Ensure creation (or removal) of Barman files and directories
  $ensure_file = $ensure ? {
    'absent' => 'absent',
    default  => 'present',
  }
  $ensure_directory = $ensure ? {
    'absent' => 'absent',
    default  => 'directory',
  }

  if $manage_package_repo {
    if defined(Class['postgresql::globals']) {
      fail('Class postgresql::globals is already defined. Set barman class manage_package_repo parameter to false (preferred) or remove the other definition.')
    } else {
      class { 'postgresql::globals':
        manage_package_repo => true,
      }
    }
  }
  package { 'barman':
    ensure => $ensure,
    tag    => 'postgresql',
  }

  file { '/etc/barman.d':
    ensure  => $ensure_directory,
    purge   => $purge_unknown_conf,
    recurse => true,
    owner   => 'root',
    group   => $group,
    mode    => '0750',
    require => Package['barman'],
  }

  if $conf_file_path == '/etc/barman/barman.conf' {
    file { '/etc/barman':
      ensure  => $ensure_directory,
      purge   => $purge_unknown_conf,
      recurse => true,
      owner   => 'root',
      group   => $group,
      mode    => '0750',
      require => Package['barman'],
    }

    file { $conf_file_path:
      ensure  => $ensure_file,
      owner   => 'root',
      group   => $group,
      mode    => '0640',
      content => template($conf_template),
      require => File['/etc/barman'],
    }
  } else {
    file { $conf_file_path:
      ensure  => $ensure_file,
      owner   => 'root',
      group   => $group,
      mode    => '0640',
      content => template($conf_template),
    }
  }

  file { $home:
    ensure  => $ensure_directory,
    owner   => $user,
    group   => $group,
    mode    => $home_mode,
    require => Package['barman'],
  }

  if $manage_ssh_host_keys {
    file { "${home}/.ssh":
      ensure  => directory,
      owner   => $user,
      group   => $group,
      mode    => '0700',
      require => File[$home],
    }

    file { "${home}/.ssh/known_hosts":
      ensure => file,
      owner  => $user,
      group  => $group,
      mode   => '0600',
    }
  }

  # Run 'barman check all' to create Barman backup directories
  exec { 'barman-check-all':
    command     => '/usr/bin/barman check all',
    subscribe   => File[$home],
    refreshonly => true,
  }

  file { '/etc/logrotate.d/barman':
    ensure  => $ensure_file,
    owner   => 'root',
    group   => 0,
    mode    => '0644',
    content => template($logrotate_template),
    require => Package['barman'],
  }

  # Set the autoconfiguration
  if $autoconfigure {
    class { 'barman::autoconfigure':
      exported_ipaddress => $exported_ipaddress,
      host_group         => $host_group,
      archive_cmd_type   => $archive_cmd_type,
    }
  }
}
