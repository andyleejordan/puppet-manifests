# nodes.pp

node 'vagrant' inherits default {
}

node 'krikkit.schwartzmeyer.com' inherits default {

  prosody::virtualhost { 'schwartzmeyer.com':
    ensure   => present,
  }

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

  file { $backup_path:
    ensure  => directory,
  }

  mount { $backup_path:
    ensure    => mounted,
    fstype    => 'vboxsf',
    device    => 'backup',
    options   => [ 'rw', 'uid=andrew', 'gid=andrew' ],
    subscribe => File[$backup_path],
    require   => User['andrew'],
  }
}

node default {

  # create users
  $persons = {}
  $person_defaults = {}
  create_resources('person', $persons, $person_defaults)

  # hiera ssh keys
  $ssh_keys = {}
  $ssh_key_defaults = {}
  create_resources('ssh_authorized_key', $ssh_keys, $ssh_key_defaults)

  # hiera packages
  $packages = []
  ensure_packages($packages)

  # dependencies
  ensure_packages([ 'git', 'python', 'python-pip', 'zsh' ])

  package { [ 'virtualenvwrapper', 'pyrax' ]:
    ensure   => latest,
    provider => pip,
    require  => Package['python-pip']
  }

  Vcsrepo <| provider == git |> {
    require => Package['git']
  }
}
