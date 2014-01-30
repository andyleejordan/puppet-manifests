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

  $ssh_keys = {}
  $ssh_key_defaults = {}
  create_resources('ssh_authorized_key', $ssh_keys, $ssh_key_defaults)

  $packages = []
  $dependencies = [ 'python', 'python-pip', 'zsh' ]
  ensure_resource('package', $packages, { 'ensure' => 'present' })
  ensure_resource('package', $dependencies, { 'ensure' => 'present' })
  ensure_resource('package', 'git', { 'ensure' => 'latest' })

  package { 'virtualenvwrapper':
    ensure   => latest,
    provider => pip,
    require  => Package['python-pip']
  }

  Vcsrepo <| provider == git |> {
    require => Package['git']
  }
}
