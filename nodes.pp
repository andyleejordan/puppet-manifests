# nodes.pp

node 'vagrant' inherits default {
}

node 'krikkit.schwartzmeyer.com' inherits default {

  vcsrepo { '/var/www/idahothegoodlife.com':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/andschwa/idahothegoodlife.com.git',
    revision => 'master',
  }
}


node 'slartibartfast.schwartzmeyer.us' inherits default {

  # shared VBox folder backup
  $backup_path = '/mnt/backup'
  $stuff_path  = '/mnt/stuff'

  file { [$backup_path, $stuff_path]:
    ensure  => directory,
  }

  Mount {
    ensure    => mounted,
    fstype    => 'vboxsf',
    options   => [ 'rw', 'uid=andrew', 'gid=andrew' ],
  }

  mount { $backup_path:
    device    => 'backup',
    subscribe => File[$backup_path],
  }

  mount { $stuff_path:
    device    => 'stuff',
    subscribe => File[$stuff_path],
  }
}

node default {
  # hiera ssh keys
  create_resources('ssh_authorized_key', hiera_hash('ssh_keys', {}), hiera_hash('ssh_key_defaults', {}))

  # hiera packages
  ensure_packages(hiera_array('common_packages', []))

  # dependencies
  ensure_packages(['git', 'python', 'python-pip'])

  $common_pip_packages = hiera_array('common_pip_packages')
  package { $common_pip_packages:
    ensure   => latest,
    provider => pip,
    require  => Package['python-pip']
  }

  Vcsrepo <| provider == git |> {
    require => Package['git']
  }
}
