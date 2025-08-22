# == Class: barman
#
# This class:
#
# * Creates the .pgpass file for the 'barman' user
# * Imports resources exported by PostgreSQL server
# ** to set cron
# ** to import SSH key of 'postgres' user
# ** to fill the .pgpass file
# ** to configure Barman (fill .conf files)
# * Exports Barman resources to the PostgreSQL server
# ** to set the 'archive_command' in postgresql.conf
# ** to export the SSH key of 'barman' user
# ** to configure the pg_hba.conf
#
# === Parameters
#
# @param host_group
#   Tag the different host groups for the backup
#   (default value is set from the 'settings' class).
# @param exported_ipaddress
#   The barman server address to allow in the PostgreSQL
#   server ph_hba.conf. Defaults to "${::ipaddress}/32".
# @param archive_cmd_type
#   The archive command to use - either rsync (default) or
#   barman-wal-archive
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
class barman::autoconfigure (
  String              $host_group         = $barman::host_group,
  Stdlib::IP::Address $exported_ipaddress = "${facts['networking']['ip']}/32",
  String              $archive_cmd_type   = 'rsync',
) {
  # create the (empty) .pgpass file
  file { "${barman::home}/.pgpass":
    ensure  => 'file',
    owner   => $barman::user,
    group   => $barman::group,
    mode    => '0600',
    require => Class['barman'],
  }

  ############ Import Resources exported by Postgres Servers

  # This fill the .pgpass file
  File_line <<| tag == "barman-${host_group}" |>>

  # Import all needed information for the 'server' class
  Barman::Server <<| tag == "barman-${host_group}" |>> {
    require     => Class['barman'],
  }

  # Add crontab
  Cron <<| tag == "barman-${host_group}" |>> {
    require => Class['barman'],
  }

  # Import 'postgres' key
  Ssh_authorized_key <<| tag == "barman-${host_group}-postgresql" |>> {
    require => Class['barman'],
  }

  if $barman::manage_ssh_host_keys {
    Sshkey <<| tag == "barman-${host_group}-postgresql" |>> {
      require => Class['barman'],
    }
  }
  ############## Export resources to Postgres Servers

  # export the archive command
  @@barman::archive_command { $barman::barman_fqdn :
    tag              => "barman-${host_group}",
    barman_home      => $barman::home,
    barman_user      => $barman::user,
    archive_cmd_type => $archive_cmd_type,
  }

  if $barman::manage_ssh_host_keys {
    @@sshkey { "barman-${facts['networking']['fqdn']}":
      ensure       => present,
      host_aliases => [$facts['networking']['hostname'], $facts['networking']['fqdn'], $facts['networking']['ip']],
      key          => $facts['ssh']['ecdsa']['key'],
      type         => 'ecdsa-sha2-nistp256',
      target       => '/var/lib/postgresql/.ssh/known_hosts',
      tag          => "barman-${host_group}",
    }
  }

  # export the 'barman' SSH key - create if not present
  # generated using Facter function
  if ($facts['barman_key'] != undef and $facts['barman_key'] != '') {
    $barman_key_splitted = split($facts['barman_key'], ' ')
    @@ssh_authorized_key { "postgres-${barman::barman_fqdn}":
      ensure => present,
      user   => 'postgres',
      type   => $barman_key_splitted[0],
      key    => $barman_key_splitted[1],
      tag    => "barman-${host_group}",
    }
  }
}
