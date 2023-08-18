# == Resource: barman::server
#
# This resource creates a barman configuration for a postgresql instance.
#
# NOTE: The resource is called in the 'postgres' class.
#
# === Parameters
#
# Many of the main configuration parameters can ( and *must*) be passed in
# order to perform overrides.
#
# [*conninfo*] - Postgres connection string. *Mandatory*.
# [*ssh_command*] - Command to open an ssh connection to Postgres. *Mandatory*.
# [*active*] - Whether this server is active in the barman configuration.
# [*server_name*] - Name of the server
# [*ensure*] - Ensure (or not) that single server Barman configuration files are
#              created. The default value is 'present'. Just 'absent' or
#              'present' are the possible settings.
# [*conf_template*] - path of the template file to build the Barman
#                     configuration file.
# [*description*] - Description of the configuration file: it is automatically
#                   set when the resource is used.
# [*archiver*] - Whether the log shipping backup mechanism is active or not.
# [*archiver_batch_size*] - Setting this option enables batch processing of WAL
#                           files. The default processes all currently available
#                           files.
# [*backup_directory*] - Directory where backup data for a server will be placed.
# [*backup_method*] - Configure the method barman used for backup execution. If
#                     set to rsync (default), barman will execute backup using the
#                     rsync command. If set to postgres barman will use the
#                     pg_basebackup command to execute the backup.
# [*backup_options*] - Behavior for backup operations: possible values are
#                      exclusive_backup (default) and concurrent_backup.
# [*recovery_options*] - The restore command to write in the recovery.conf.
#                        Possible values are 'get-wal' and undef. Default: undef.
# [*bandwidth_limit*] - This option allows you to specify a maximum transfer rate
#                       in kilobytes per second. A value of zero specifies no
#                       limit (default).
# [*basebackups_directory*] - Directory where base backups will be placed.
# [*basebackup_retry_sleep*] - Number of seconds of wait after a failed copy,
#                              before retrying Used during both backup and
#                              recovery operations. Positive integer, default 30.
# [*basebackup_retry_times*] - Number of retries of base backup copy, after an
#                              error. Used during both backup and recovery
#                              operations. Positive integer, default 0.
# [*check_timeout*] - Maximum execution time, in seconds per server, for a barman
#                     check command. Set to 0 to disable the timeout. Positive
#                     integer, default 30.
# [*compression*] - Compression algorithm. Currently supports 'gzip' (default),
#                   'bzip2', and 'custom'. Disabled if false.
# [*custom_compression_filter*] - Customised compression algorithm applied to WAL
#                                 files.
# [*custom_decompression_filter*] - Customised decompression algorithm applied to
#                                   compressed WAL files; this must match the
#                                   compression algorithm.
# [*errors_directory*] - Directory that contains WAL files that contain an error.
# [*immediate_checkpoint*] - Force the checkpoint on the Postgres server to
#                            happen immediately and start your backup copy
#                            process as soon as possible. Disabled if false
#                            (default)
# [*incoming_wals_directory*] - Directory where incoming WAL files are archived
#                               into. Requires archiver to be enabled.
# [*last_backup_maximum_age*] - This option identifies a time frame that must
#                               contain the latest backup. If the latest backup is
#                               older than the time frame, barman check command
#                               will report an error to the user. If empty
#                               (default), latest backup is always considered
#                               valid. Syntax for this option is: "i (DAYS |
#                               WEEKS | MONTHS)" where i is a integer greater than
#                               zero, representing the number of days | weeks |
#                               months of the time frame.
# [*minimum_redundancy*] - Minimum number of backups to be retained. Default 0.
# [*network_compression*] - This option allows you to enable data compression for
#                           network transfers. Defaults to false.
# [*parallel_jobs] - Number of parallel workers used to copy files during
#                    backup or recovery. Requires backup mode = rsync.
# [*path_prefix*] - One or more absolute paths, separated by colon, where Barman
#                   looks for executable files.
# [*post_archive_retry_script*] - Hook script launched after a WAL file is
#                                 archived by maintenance. Being this a retry hook
#                                 script, Barman will retry the execution of the
#                                 script until this either returns a SUCCESS (0),
#                                 an ABORT_CONTINUE (62) or an ABORT_STOP (63)
#                                 code. In a post archive scenario, ABORT_STOP has
#                                 currently the same effects as ABORT_CONTINUE.
# [*post_archive_script*] - Hook script launched after a WAL file is archived by
#                           maintenance, after 'post_archive_retry_script'.
# [*post_backup_retry_script*] - Hook script launched after a base backup. Being
#                                this a retry hook script, Barman will retry the
#                                execution of the script until this either returns
#                                a SUCCESS (0), an ABORT_CONTINUE (62) or an
#                                ABORT_STOP (63) code. In a post backup scenario,
#                                ABORT_STOP has currently the same effects as
#                                ABORT_CONTINUE.
# [*post_backup_script*] - Hook script launched after a base backup, after
#                          'post_backup_retry_script'.
# [*pre_archive_retry_script*] - Hook script launched before a WAL file is
#                                archived by maintenance, after
#                                'pre_archive_script'. Being this a retry hook
#                                script, Barman will retry the execution of the
#                                script until this either returns a SUCCESS (0),
#                                an ABORT_CONTINUE (62) or an ABORT_STOP (63)
#                                code. Returning ABORT_STOP will propagate the
#                                failure at a higher level and interrupt the WAL
#                                archiving operation.
# [*pre_archive_script*] - Hook script launched before a WAL file is archived by
# 			   maintenance.
# [*pre_backup_retry_script*] - Hook script launched before a base backup, after
#                               'pre_backup_script'. Being this a retry hook
#                               script, Barman will retry the execution of the
#                               script until this either returns a SUCCESS (0), an
#                               ABORT_CONTINUE (62) or an ABORT_STOP (63) code.
#                               Returning ABORT_STOP will propagate the failure at
#                               a higher level and interrupt the backup operation.
# [*pre_backup_script*] - Hook script launched before a base backup.
# [*retention_policy*] - Base backup retention policy, based on redundancy or
#                        recovery window. Default empty (no retention enforced).
#                        Value must be greater than or equal to the server
#                        minimum redundancy level (if not is is assigned to
#                        that value and a warning is generated).
# [*retention_policy_mode*] - Can only be set to auto (retention policies are
#                             automatically enforced by the barman cron command)
# [*reuse_backup*] - Incremental backup is a kind of full periodic backup which
#                    saves only data changes from the latest full backup
#                    available in the catalogue for a specific PostgreSQL
#                    server. Disabled if false. Default false.
# [*slot_name*] - Physical replication slot to be used by the receive-wal
#                 command when streaming_archiver is set to on. Requires
#                 postgreSQL >= 9.4. Default: undef (disabled).
# [*streaming_archiver*] - This option allows you to use the PostgreSQL's
#                          streaming protocol to receive transaction logs from a
#                          server. This activates connection checks as well as
#                          management (including compression) of WAL files. If
#                          set to off (default) barman will rely only on
#                          continuous archiving for a server WAL archive
#                          operations, eventually terminating any running
#                          pg_receivexlog for the server.
# [*streaming_archiver_batch_size*] - This option allows you to activate batch
#                                     processing of WAL files for the
#                                     streaming_archiver process, by setting it to
#                                     a value > 0. Otherwise, the traditional
#                                     unlimited processing of the WAL queue is
#                                     enabled.
# [*streaming_archiver_name*] - Identifier to be used as application_name by the
#                               receive-wal command. Only available with
#                               pg_receivexlog >= 9.3. By default it is set to
#                               barman_receive_wal.
# [*streaming_backup_name*] - Identifier to be used as application_name by the
#                             pg_basebackup command. Only available with
#                             pg_basebackup >= 9.3. By default it is set to
#                             barman_streaming_backup.
# [*streaming_conninfo*] - Connection string used by Barman to connect to the
#                          Postgres server via streaming replication protocol. By
#                          default it is set to the same value as *conninfo*.
# [*streaming_wals_directory*] - Directory where WAL files are streamed from the
#                                PostgreSQL server to Barman.
# [*tablespace_bandwidth_limit*] - This option allows you to specify a maximum
#                                  transfer rate in kilobytes per second, by
#                                  specifying a comma separated list of
#                                  tablespaces (pairs TBNAME:BWLIMIT). A value of
#                                  zero specifies no limit (default).
# [*wal_retention_policy*] - WAL archive logs retention policy. Currently, the
#                            only allowed value for wal_retention_policy is the
#                            special value main, that maps the retention policy
#                            of archive logs to that of base backups.
# [*wals_directory*] - Directory which contains WAL files.
# [*custom_lines*] - DEPRECATED. Custom configuration directives (e.g. for
#                    custom compression). Defaults to empty.
# === Examples
#
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
  Optional[String]               $custom_compression_filter     = $barman::custom_compression_filter,
  Optional[String]               $custom_decompression_filter   = $barman::custom_decompression_filter,
  Optional[Stdlib::Absolutepath] $errors_directory              = undef,
  Boolean                        $immediate_checkpoint          = $barman::immediate_checkpoint,
  Optional[Stdlib::Absolutepath] $incoming_wals_directory       = undef,
  Barman::BackupAge              $last_backup_maximum_age       = $barman::last_backup_maximum_age,
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
