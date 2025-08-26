# @summary This class export resources to the Barman server (Barman configurations,
# cron, SSH key) and import resources from it (configure 'archive_mode',
# define user used by Barman to connect into PostgreSQL database(s)).
#
# @example The class can be used right away with defaults:
#   include postgres
#
# @example All parameters that are supported by barman can be changed:
#  class { postgres :
#    backup_hour   => 4,
#    backup_minute => 0,
#    password      => 'not_needed',
#    postgres_user => 'postgres',
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
# @param manage_barman_server
#   Whether barman server config should be exported, default: `true`
# @param host_group
# Tag the different host groups for the backup
#                  (default value is set from the 'settings' class).
# @param manage_dbuser
#   Whether db role should be managed, default: `true`
# @param manage_ssh_host_keys
# When using autoconfigure, ensure the hosts contain
#                            each other ssh host key. Must also be set on 'barman'
#                            class. Defaults to false.
# @param wal_level
# Configuration of the 'wal_level' parameter in the
#                 postgresql.conf file. The default value is 'archive'.
# @param barman_user
# Definition of the 'barman' user used in Barman 'conninfo'.
#                   The default value is set from the 'settings' class.
# @param barman_dbname
#  Name of the barman DB
# @param barman_dbuser
# Definition of the user used by Barman to connect to the
#                     PostgreSQL database(s) in the 'conninfo'. The default
#                     value is set from the 'settings' class.
# @param barman_home
# Definition of the barman home directory. The default value
#                   is set from the 'settings' class.
# @param manage_cron
# Whether cron entry should be managed.
# @param conninfo_options
# Additional connection options passed to the conninfo string.
#                   The default value is undef.
# @param cron_user
# User to run cron jobs.
# @param backup_mday
# Day of the month set in the cron for the backup schedule.
#                   The default value (undef) ensure daily backups.
# @param backup_wday
# Day of the week set in the cron for the backup schedule.
#                   The default value (undef) ensure daily backups.
# @param backup_hour
# Hour set in the cron for the backup schedule. The default
#                   value is 04:XXam.
# @param backup_minute
# Minute set in the cron for the backup schedule. The
#                     default value is for XX:00am
# @param password
# Password used by Barman to connect to PosgreSQL. The default
#                value (empty string) allows the generation of a random
#                password.
# @param server_address
# The whole fqdn of the PostgreSQL server used in Barman
#                      'ssh_command' (automatically configured by Puppet).
# @param server_port
# The port used by PostgreSQL for receiving connections
#                   (default: 5432)
# @param postgres_server_id
# Id of the PostgreSQL server, given by its host name
#                          (automatically configured by Puppet).
# @param postgres_user
# The PostgreSQL user used in Barman 'ssh_command'.
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
# @param force_archive_mode
#  Configure archive mode regardless of archiver settings
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
#                          maintenance.
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
#   DEPRECATED. Custom configuration directives (e.g. for custom compression). Defaults to empty.
#
class barman::postgres (
  Boolean                               $manage_barman_server          = true,
  Boolean                               $manage_dbuser                 = true,
  String                                $host_group                    = $barman::host_group,
  String                                $wal_level                     = 'archive',
  String                                $barman_user                   = $barman::user,
  String                                $barman_dbuser                 = $barman::dbuser,
  String                                $barman_dbname                 = $barman::dbname,
  String                                $barman_home                   = $barman::home,
  Boolean                               $manage_cron                   = true,
  Optional[String]                      $conninfo_options              = undef,
  String                                $cron_user                     = 'root',
  Optional[Integer]                     $backup_mday                   = undef,
  Optional[Integer]                     $backup_wday                   = undef,
  Integer                               $backup_hour                   = 4,
  Integer                               $backup_minute                 = 0,
  Barman::Password                      $password                      = undef,
  String                                $server_address                = $facts['networking']['fqdn'],
  Integer                               $server_port                   = 5432,
  String                                $postgres_server_id            = $facts['networking']['hostname'],
  String                                $postgres_user                 = 'postgres',
  String                                $ensure                        = 'present',
  String                                $conf_template                 = 'barman/server.conf.erb',
  String                                $description                   = $name,
  Boolean                               $archiver                      = $barman::archiver,
  Optional[Integer]                     $archiver_batch_size           = $barman::archiver_batch_size,
  Optional[Enum['on', 'off', 'always']] $force_archive_mode            = undef,
  Optional[Stdlib::Absolutepath]        $backup_directory              = undef,
  Barman::BackupMethod                  $backup_method                 = $barman::backup_method,
  Barman::BackupOptions                 $backup_options                = $barman::backup_options,
  Optional[Integer]                     $bandwidth_limit               = $barman::bandwidth_limit,
  Optional[Stdlib::Absolutepath]        $basebackups_directory         = undef,
  Optional[Integer]                     $basebackup_retry_sleep        = $barman::basebackup_retry_sleep,
  Optional[Integer]                     $basebackup_retry_times        = $barman::basebackup_retry_times,
  Optional[Integer]                     $check_timeout                 = $barman::check_timeout,
  Variant[String,Boolean]               $compression                   = $barman::compression,
  Optional[String]                      $custom_compression_filter     = $barman::custom_compression_filter,
  Optional[String]                      $custom_decompression_filter   = $barman::custom_decompression_filter,
  Optional[Stdlib::Absolutepath]        $errors_directory              = undef,
  Boolean                               $immediate_checkpoint          = $barman::immediate_checkpoint,
  Optional[Stdlib::Absolutepath]        $incoming_wals_directory       = undef,
  Barman::BackupAge                     $last_backup_maximum_age       = $barman::last_backup_maximum_age,
  Barman::BackupAge                     $last_wal_maximum_age          = $barman::last_wal_maximum_age,
  Barman::BackupSize                    $last_backup_minimum_size      = $barman::last_backup_minimum_size,
  Integer                               $minimum_redundancy            = $barman::minimum_redundancy,
  Boolean                               $manage_ssh_host_keys          = $barman::manage_ssh_host_keys,
  Optional[Boolean]                     $network_compression           = $barman::network_compression,
  Optional[Integer]                     $parallel_jobs                 = $barman::parallel_jobs,
  Optional[Stdlib::Absolutepath]        $path_prefix                   = $barman::path_prefix,
  Optional[String]                      $post_archive_retry_script     = $barman::post_archive_retry_script,
  Optional[String]                      $post_archive_script           = $barman::post_archive_script,
  Optional[String]                      $post_backup_retry_script      = $barman::post_backup_retry_script,
  Optional[String]                      $post_backup_script            = $barman::post_backup_script,
  Optional[String]                      $pre_archive_retry_script      = $barman::pre_archive_retry_script,
  Optional[String]                      $pre_archive_script            = $barman::pre_archive_script,
  Optional[String]                      $pre_backup_retry_script       = $barman::pre_backup_retry_script,
  Optional[String]                      $pre_backup_script             = $barman::pre_backup_script,
  Barman::RecoveryOptions               $recovery_options              = $barman::recovery_options,
  Barman::RetentionPolicy               $retention_policy              = $barman::retention_policy,
  Barman::RetentionPolicyMode           $retention_policy_mode         = $barman::retention_policy_mode,
  Barman::ReuseBackup                   $reuse_backup                  = $barman::reuse_backup,
  Optional[String]                      $slot_name                     = $barman::slot_name,
  Boolean                               $streaming_archiver            = $barman::streaming_archiver,
  Optional[Integer]                     $streaming_archiver_batch_size = $barman::streaming_archiver_batch_size,
  Optional[String]                      $streaming_archiver_name       = $barman::streaming_archiver_name,
  Optional[String]                      $streaming_backup_name         = $barman::streaming_backup_name,
  Optional[String]                      $streaming_conninfo            = undef,
  Optional[Stdlib::Absolutepath]        $streaming_wals_directory      = $barman::streaming_wals_directory,
  Optional[String]                      $tablespace_bandwidth_limit    = $barman::tablespace_bandwidth_limit,
  Barman::WalRetention                  $wal_retention_policy          = $barman::wal_retention_policy,
  Optional[Stdlib::Absolutepath]        $wals_directory                = undef,
  Optional[String]                      $custom_lines                  = $barman::custom_lines,
) {
  if !defined(Class['postgresql::server']) {
    fail('barman::server requires the postgresql::server module installed and configured')
  }

  # Generate a new password if not defined
  $real_password = $password ? {
    undef   => fqdn_rand_string(30,'','fwsfbsfw'),
    default => $password,
  }

  if $force_archive_mode {
    $archive_mode = $force_archive_mode
  } else {
    $archive_mode = $archiver ? {
      true    => 'on',
      default => 'off',
    }
  }

  # Configure PostgreSQL server for archive mode
  postgresql::server::config_entry {
    'archive_mode': value => $archive_mode;
    'wal_level': value => $wal_level;
  }

  # define user used by Barman to connect into PostgreSQL database(s)
  if $manage_dbuser {
    postgresql::server::role { $barman_dbuser:
      login         => true,
      password_hash => postgresql::postgresql_password($barman_dbuser, $real_password),
      superuser     => true,
    }
  }

  # Collect resources exported by Barman server
  Postgresql::Server::Pg_hba_rule <<| tag == "barman-${host_group}" |>>

  Ssh_authorized_key <<| tag == "barman-${host_group}" |>> {
    require => Class['postgresql::server'],
  }

  # Export resources to Barman server
  if $manage_barman_server {
    @@barman::server { $postgres_server_id:
      conninfo                      => "user=${barman_dbuser} dbname=${barman_dbname} host=${server_address} port=${server_port} ${conninfo_options}",
      ssh_command                   => "ssh -q ${postgres_user}@${server_address}",
      tag                           => "barman-${host_group}",
      archiver                      => $archiver,
      archiver_batch_size           => $archiver_batch_size,
      backup_directory              => $backup_directory,
      backup_method                 => $backup_method,
      backup_options                => $backup_options,
      bandwidth_limit               => $bandwidth_limit,
      basebackups_directory         => $basebackups_directory,
      basebackup_retry_sleep        => $basebackup_retry_sleep,
      basebackup_retry_times        => $basebackup_retry_times,
      check_timeout                 => $check_timeout,
      compression                   => $compression,
      custom_compression_filter     => $custom_compression_filter,
      custom_decompression_filter   => $custom_decompression_filter,
      errors_directory              => $errors_directory,
      immediate_checkpoint          => $immediate_checkpoint,
      incoming_wals_directory       => $incoming_wals_directory,
      last_backup_maximum_age       => $last_backup_maximum_age,
      last_wal_maximum_age          => $last_wal_maximum_age,
      last_backup_minimum_size      => $last_backup_minimum_size,
      minimum_redundancy            => $minimum_redundancy,
      network_compression           => $network_compression,
      path_prefix                   => $path_prefix,
      parallel_jobs                 => $parallel_jobs,
      post_archive_retry_script     => $post_archive_retry_script,
      post_archive_script           => $post_archive_script,
      post_backup_retry_script      => $post_backup_retry_script,
      post_backup_script            => $post_backup_script,
      pre_archive_retry_script      => $pre_archive_retry_script,
      pre_archive_script            => $pre_archive_script,
      pre_backup_retry_script       => $pre_backup_retry_script,
      pre_backup_script             => $pre_backup_script,
      retention_policy              => $retention_policy,
      retention_policy_mode         => $retention_policy_mode,
      reuse_backup                  => $reuse_backup,
      slot_name                     => $slot_name,
      streaming_archiver            => $streaming_archiver,
      streaming_archiver_batch_size => $streaming_archiver_batch_size,
      streaming_archiver_name       => $streaming_archiver_name,
      streaming_backup_name         => $streaming_backup_name,
      streaming_conninfo            => $streaming_conninfo,
      streaming_wals_directory      => $streaming_wals_directory,
      tablespace_bandwidth_limit    => $tablespace_bandwidth_limit,
      wal_retention_policy          => $wal_retention_policy,
      wals_directory                => $wals_directory,
      custom_lines                  => $custom_lines,
    }
  }

  if $manage_cron {
    @@cron { "barman_backup_${postgres_server_id}":
      command  => "[ -x /usr/bin/barman ] && /usr/bin/barman -q backup --wait ${postgres_server_id}",
      user     => $cron_user,
      monthday => $backup_mday,
      weekday  => $backup_wday,
      hour     => $backup_hour,
      minute   => $backup_minute,
      tag      => "barman-${host_group}",
    }
  }

  # Fill the .pgpass file
  @@file_line { "barman_pgpass_content-${postgres_server_id}":
    path  => "${barman_home}/.pgpass",
    line  => "${server_address}:${server_port}:${barman_dbname}:${barman_dbuser}:${real_password}",
    match => "^${regexpescape($server_address)}:${server_port}:${barman_dbname}:${barman_dbuser}",
    tag   => "barman-${host_group}",
  }
  if $streaming_archiver or $backup_method == 'postgres' {
    @@file_line { "barman_pgpass_content-${postgres_server_id}-replication":
      path  => "${barman_home}/.pgpass",
      line  => "${server_address}:${server_port}:replication:${barman_dbuser}:${real_password}",
      match => "^${regexpescape($server_address)}:${server_port}:replication:${barman_dbuser}",
      tag   => "barman-${host_group}",
    }
  }

  if $manage_ssh_host_keys {
    @@sshkey { "postgres-${postgres_server_id}":
      ensure       => present,
      host_aliases => [$facts['networking']['hostname'], $facts['networking']['fqdn'], $facts['networking']['ip'], $server_address],
      key          => $facts['ssh']['ecdsa']['key'],
      type         => 'ecdsa-sha2-nistp256',
      target       => "${barman_home}/.ssh/known_hosts",
      tag          => "barman-${host_group}-postgresql",
    }
    Sshkey <<| tag == "barman-${host_group}" |>>
  }

  if $archiver {
    # If barman archiver is enabled, export the ssh key of postgres user
    # into barman and set the archive command
    if ($facts['postgres_key'] != undef and $facts['postgres_key'] != '') {
      $postgres_key_split = split($facts['postgres_key'], ' ')
      @@ssh_authorized_key { "postgres-${postgres_server_id}":
        ensure => present,
        user   => $barman_user,
        type   => $postgres_key_split[0],
        key    => $postgres_key_split[1],
        tag    => "barman-${host_group}-postgresql",
      }
    }
    Barman::Archive_command <<| tag == "barman-${host_group}" |>> {
      postgres_server_id => $postgres_server_id,
    }
  }
}
