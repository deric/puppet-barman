# == Class: archive_command
#
# Build the correct archive command which will be exported to the PostgreSQL server
#
# === Parameters
#
# @param postgres_server_id
#   Tag for the PostgreSQL server. The default value (the host name)
#   should be fine, so you don't need to change this.
# @param barman_user
#   The default value is the one contained in the 'settings' class.
# @param barman_home
#   Home directory
# @param barman_server
#   The value is set when the resource is created
#   (in the 'autoconfigure' class).
# @param barman_incoming_dir
#   The Barman WAL incoming directory. The default value will be
#   generated here to be something like
#                           '<barman home>/<postgres_server_id>/incoming'
# @param archive_cmd_type
#   The archive command to use, either rsync or barman-wal-archive,
#                        defaults to rsync
#
# All parameters that are supported can be changed when the resource 'archive' is
# created in the 'autoconfigure' class.
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
define barman::archive_command (
  String $postgres_server_id  = 'default',
  String $barman_user         = $barman::user,
  String $barman_server       = $title,
  String $barman_home         = $barman::home,
  String $barman_incoming_dir = '',
  String $archive_cmd_type    = 'rsync',
) {
  # Ensure that 'postgres' class correctly configure the 'archive_command'
  if $postgres_server_id == 'default'
  and $barman_incoming_dir == '' {
    fail 'You must pass either postgres_server_id or barman_incoming_dir'
  }

  # Generate path if not explicitely defined
  $real_barman_incoming_dir = $barman_incoming_dir ? {
    ''      => "${barman_home}/${postgres_server_id}/incoming",
    default => $barman_incoming_dir,
  }

  case $archive_cmd_type {
    'barman-wal-archive': {
      $archive_cmd_real = "barman-wal-archive -U ${barman_user} ${barman_server} ${postgres_server_id} %p"
    }
    default: {
      $archive_cmd_real = "rsync -a %p ${barman_user}@${barman_server}:${real_barman_incoming_dir}/%f"
    }
  }

  postgresql::server::config_entry { "archive_command_${title}":
    name  => 'archive_command',
    value => $archive_cmd_real,
  }
}
