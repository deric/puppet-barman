# @summary Creates a barman configuration for a postgresql instance.
#
# NOTE: The resource is called in the 'postgres' class.
# @example
#  barman::server { 'main':
#    conninfo           => 'user=postgres host=server1 password=pg123',
#    ssh_command        => 'ssh postgres@server1',
#    compression        => 'bzip2',
#    pre_backup_script  => '/usr/bin/touch /tmp/started',
#    post_backup_script => '/usr/bin/touch /tmp/stopped',
#    custom_lines       => '; something'
#  }
# ---
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
# === Parameters
#
# Many of the main configuration parameters can ( and *must*) be passed in
# order to perform overrides.
#
# @param conninfo
# Postgres connection string. *Mandatory*.
# @param ssh_command
# Command to open an ssh connection to Postgres. *Mandatory*.
# @param active
# Whether this server is active in the barman configuration.
# @param server_name
# Name of the server
# @param ensure
# Ensure (or not) that single server Barman configuration files are
#              created. The default value is 'present'. Just 'absent' or
#              'present' are the possible settings.
# @param conf_template
# path of the template file to build the Barman
#                     configuration file.
# @param description
# Description of the configuration file: it is automatically
#                   set when the resource is used.
# @param archiver
# Whether the log shipping backup mechanism is active or not.
# @param archiver_batch_size
# Setting this option enables batch processing of WAL
#                           files. The default processes all currently available
#                           files.
# @param backup_directory
# Directory where backup data for a server will be placed.
# @param backup_method
# Configure the method barman used for backup execution. If
#                     set to rsync (default), barman will execute backup using the
#                     rsync command. If set to postgres barman will use the
#                     pg_basebackup command to execute the backup.
# @param backup_options
# Behavior for backup operations: possible values are
#                      exclusive_backup (default) and concurrent_backup.
# @param recovery_options
# The restore command to write in the recovery.conf.
#                        Possible values are 'get-wal' and undef. Default: undef.
# @param bandwidth_limit
# This option allows you to specify a maximum transfer rate
#                       in kilobytes per second. A value of zero specifies no
#                       limit (default).
# @param basebackups_directory
# Directory where base backups will be placed.
# @param basebackup_retry_sleep
# Number of seconds of wait after a failed copy,
#                              before retrying Used during both backup and
#                              recovery operations. Positive integer, default 30.
# @param basebackup_retry_times
# Number of retries of base backup copy, after an
#                              error. Used during both backup and recovery
#                              operations. Positive integer, default 0.
# @param check_timeout
# Maximum execution time, in seconds per server, for a barman
#                     check command. Set to 0 to disable the timeout. Positive
#                     integer, default 30.
# @param compression
# Compression algorithm. Currently supports 'gzip' (default),
#                   'bzip2', and 'custom'. Disabled if false.
# @param create_slot
# Determines whether Barman should automatically create a replication slot if it’s
#                    not already present for streaming WAL files.
#                    One of 'auto' or 'manual' (default).
# @param custom_compression_filter
# Customised compression algorithm applied to WAL
#                                 files.
# @param custom_decompression_filter
# Customised decompression algorithm applied to
#                                   compressed WAL files; this must match the
#                                   compression algorithm.
# @param errors_directory
# Directory that contains WAL files that contain an error.
# @param immediate_checkpoint
# Force the checkpoint on the Postgres server to
#                            happen immediately and start your backup copy
#                            process as soon as possible. Disabled if false
#                            (default)
# @param incoming_wals_directory
# Directory where incoming WAL files are archived
#                               into. Requires archiver to be enabled.
# @param last_backup_maximum_age
#   Defines the time frame within which the latest backup must fall. If the latest
#   backup is older than this period, the barman check command will report an
#   error. If left empty (default), the latest backup is always considered valid.
#   The accepted format is "n {DAYS|WEEKS|MONTHS}", where n is an integer greater
#   than zero.
# @param last_wal_maximum_age
#   Defines the time frame within which the latest archived WAL file must fall. If
#   the latest WAL file is older than this period, the barman check command will
#   report an error. If left empty (default), the age of the WAL files is not
#   checked. Format is the same as last_backup_maximum_age.
# @param last_backup_minimum_size
#   Specifies the minimum acceptable size for the latest successful backup. If the
#   latest backup is smaller than this size, the barman check command will report
#   an error. If left empty (default), the latest backup is always considered
#   valid. The accepted format is "n {k|Ki|M|Mi|G|Gi|T|Ti}" and case-sensitive,
#   where n is an integer greater than zero, with an optional SI or IEC suffix.
#   k stands for kilo with k = 1000, while Ki stands for kilobytes Ki = 1024. The
#   rest of the options have the same reasoning for greater units of measure.
# @param minimum_redundancy
# Minimum number of backups to be retained. Default 0.
# @param network_compression
# This option allows you to enable data compression for
#                           network transfers. Defaults to false.
# @param parallel_jobs - Number of parallel workers used to copy files during
#                    backup or recovery. Requires backup mode = rsync.
# @param path_prefix
# One or more absolute paths, separated by colon, where Barman
#                   looks for executable files.
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
# @param primary_conninfo
# Connection string for Barman to connect to the primary Postgres server during
#                        a standby backup. Default: undef (disabled).
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
# @param streaming_conninfo
# Connection string used by Barman to connect to the
#                          Postgres server via streaming replication protocol. By
#                          default it is set to the same value as *conninfo*.
# @param streaming_wals_directory
# Directory where WAL files are streamed from the
#                                PostgreSQL server to Barman.
# @param tablespace_bandwidth_limit
# This option allows you to specify a maximum
#                                  transfer rate in kilobytes per second, by
#                                  specifying a comma separated list of
#                                  tablespaces (pairs TBNAME:BWLIMIT). A value of
#                                  zero specifies no limit (default).
# @param wal_retention_policy
# WAL archive logs retention policy. Currently, the
#                            only allowed value for wal_retention_policy is the
#                            special value main, that maps the retention policy
#                            of archive logs to that of base backups.
# @param wals_directory
# Directory which contains WAL files.
# @param custom_lines
# DEPRECATED. Custom configuration directives (e.g. for
#                    custom compression). Defaults to empty.
#
define barman::server (
  String                         $conninfo,
  String                         $ssh_command,
  Barman::ServerName             $server_name                   = $title,
  Boolean                        $active                        = true,
  Enum['present', 'absent']      $ensure                        = 'present',
  String                         $conf_template                 = 'barman/server.conf.erb',
  String                         $description                   = $title,
  Boolean                        $archiver                      = $barman::archiver,
  Optional[Integer]              $archiver_batch_size           = $barman::archiver_batch_size,
  Optional[Stdlib::Absolutepath] $backup_directory              = undef,
  Barman::BackupMethod           $backup_method                 = $barman::backup_method,
  Barman::BackupOptions          $backup_options                = $barman::backup_options,
  Optional[Integer]              $bandwidth_limit               = $barman::bandwidth_limit,
  Optional[Stdlib::Absolutepath] $basebackups_directory         = undef,
  Optional[Integer]              $basebackup_retry_sleep        = $barman::basebackup_retry_sleep,
  Optional[Integer]              $basebackup_retry_times        = $barman::basebackup_retry_times,
  Optional[Integer]              $check_timeout                 = $barman::check_timeout,
  Variant[String,Boolean]        $compression                   = $barman::compression,
  Barman::CreateSlot             $create_slot                   = $barman::create_slot,
  Optional[String]               $custom_compression_filter     = $barman::custom_compression_filter,
  Optional[String]               $custom_decompression_filter   = $barman::custom_decompression_filter,
  Optional[Stdlib::Absolutepath] $errors_directory              = undef,
  Boolean                        $immediate_checkpoint          = $barman::immediate_checkpoint,
  Optional[Stdlib::Absolutepath] $incoming_wals_directory       = undef,
  Barman::BackupAge              $last_backup_maximum_age       = $barman::last_backup_maximum_age,
  Barman::BackupAge              $last_wal_maximum_age          = $barman::last_wal_maximum_age,
  Barman::BackupSize             $last_backup_minimum_size      = $barman::last_backup_minimum_size,
  Optional[Integer]              $minimum_redundancy            = $barman::minimum_redundancy,
  Optional[Boolean]              $network_compression           = $barman::network_compression,
  Optional[Integer]              $parallel_jobs                 = $barman::parallel_jobs,
  Optional[Stdlib::Absolutepath] $path_prefix                   = $barman::path_prefix,
  Optional[String]               $post_archive_retry_script     = $barman::post_archive_retry_script,
  Optional[String]               $post_archive_script           = $barman::post_archive_script,
  Optional[String]               $post_backup_retry_script      = $barman::post_backup_retry_script,
  Optional[String]               $post_backup_script            = $barman::post_backup_script,
  Optional[String]               $pre_archive_retry_script      = $barman::pre_archive_retry_script,
  Optional[String]               $pre_archive_script            = $barman::pre_archive_script,
  Optional[String]               $pre_backup_retry_script       = $barman::pre_backup_retry_script,
  Optional[String]               $pre_backup_script             = $barman::pre_backup_script,
  Optional[String]               $primary_conninfo              = undef,
  Barman::RecoveryOptions        $recovery_options              = $barman::recovery_options,
  Barman::RetentionPolicy        $retention_policy              = $barman::retention_policy,
  Barman::RetentionPolicyMode    $retention_policy_mode         = $barman::retention_policy_mode,
  Barman::ReuseBackup            $reuse_backup                  = $barman::reuse_backup,
  Optional[String]               $slot_name                     = $barman::slot_name,
  Boolean                        $streaming_archiver            = $barman::streaming_archiver,
  Optional[Integer]              $streaming_archiver_batch_size = $barman::streaming_archiver_batch_size,
  Optional[String]               $streaming_archiver_name       = $barman::streaming_archiver_name,
  Optional[String]               $streaming_backup_name         = $barman::streaming_backup_name,
  Optional[String]               $streaming_conninfo            = undef,
  Optional[Stdlib::Absolutepath] $streaming_wals_directory      = undef,
  Optional[String]               $tablespace_bandwidth_limit    = $barman::tablespace_bandwidth_limit,
  Barman::WalRetention           $wal_retention_policy          = $barman::wal_retention_policy,
  Optional[Stdlib::Absolutepath] $wals_directory                = undef,
  Optional[String]               $custom_lines                  = $barman::custom_lines,
) {
  if $custom_lines != '' {
    notice 'The \'custom_lines\' option is deprecated. Please use $conf_template for custom configuration'
  }

  file { "/etc/barman.d/${name}.conf":
    ensure  => $ensure,
    mode    => '0640',
    owner   => $barman::user,
    group   => $barman::group,
    content => template($conf_template),
  }

  # Run 'barman check' to create Barman configuration directories
  exec { "barman-check-${name}":
    command     => "barman check ${name} || true",
    provider    => shell,
    subscribe   => File["/etc/barman.d/${name}.conf"],
    refreshonly => true,
  }

  if($barman::autoconfigure) {
    # export configuration for the pg_hba.conf
    if ($streaming_archiver or $backup_method == 'postgres') {
      @@postgresql::server::pg_hba_rule { "barman ${facts['networking']['hostname']}->${name} client access (replication)":
        description => "barman ${facts['networking']['hostname']}->${name} client access",
        type        => 'host',
        database    => 'replication',
        user        => $barman::dbuser,
        address     => $barman::autoconfigure::exported_ipaddress,
        auth_method => 'md5',
        order       => $barman::hba_entry_order,
        tag         => "barman-${barman::host_group}",
      }
    }
    @@postgresql::server::pg_hba_rule { "barman ${facts['networking']['hostname']}->${name} client access":
      description => "barman ${facts['networking']['hostname']}->${name} client access",
      type        => 'host',
      database    => $barman::dbname,
      user        => $barman::dbuser,
      address     => $barman::autoconfigure::exported_ipaddress,
      auth_method => 'md5',
      order       => $barman::hba_entry_order,
      tag         => "barman-${barman::host_group}",
    }
  }
}
