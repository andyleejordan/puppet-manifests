# nodes.pp

node "krikkit.schwartzmeyer.com" inherits default {

  prosody::virtualhost { 'schwartzmeyer.com':
      ensure => present;
  }

  nginx::resource::vhost { 'schwartzmeyer.com':
    ensure                 => present,
    www_root               => '/var/www/schwartzmeyer.com',
    rewrite_www_to_non_www => true,
  }

  $itgl_path = '/var/www/idahothegoodlife.com'
  vcsrepo { $itgl_path:
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/andschwa/idahothegoodlife.com.git',
    revision => 'master',
  }
  nginx::resource::vhost { 'idahothegoodlife.com':
    ensure                 => present,
    www_root               => $itgl_path,
    rewrite_www_to_non_www => true,
  }
}


node "slartibartfast.schwartzmeyer.us" inherits default {

  minecraft::plugin { 'dynmap':
    source => 'http://dev.bukkit.org/media/files/757/982/dynmap-1.9.1.jar'
  }

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

  $marvin_andrew = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDFigIuiNpFkXtkQzsS1pSIEEVdVoCGyQFo3tWrcPmaZ9nmwz4YeYL7yzMIrrn7omsEoggxDPlswkZq4quantaH9kVHh3rDWTMQQiYpcV1xeoBhlghNqaHRSt2FdE417ljlyYMBrJq1gJJJyDVAdBYSxPgxSE2hMUNEGdm0BHym7b7tXyk7VeRPSxcmZYH2nvELIZWJT55RufWHvGs3bKyPY4hH+wpQzpoTRTT468LHAKk1o/Jykv0XdH0lm5YCgTHjMSZGiFmXjWMxOfG7UKXG8VfTlmgEI9NlRXBc8Peqa8r46S+cQ1SlqqhkttZkkGAiypYNy6+3c30GaoGa0G8b'
  $marvin_root = 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDXZrn8SQav0ZhS3gvaznUe4QNdV/LsrGbEXcHf6bT7wUao9//jBaPMY+QEq/ltRng6eZ8rU7jRAL+hCXqFORGsPsWbwpXlHIni8oldZmxx2Ujjvp/8ojaO54ZfQg2W/8BL8xTTKRs9KJaw4Rz7NVqFrGhWCcdkpuheAkDnV6TPZgkmZyXJyhqysD5JWDMxH1YGs2jF/dGLVvB+3/TfqBUZQzmeSJEJ2PkssgkIexwEU0IZYW3N0qzAvcyGTkD/xedH7ABvXdqBZ/VADfN6y2SDLrWwsi/a6CZZwBr+jWb8q9FoaSh0Ff6qPiPH99ao9PJtojZcwMHPSpb8vwWc/kIX'

  ssh_authorized_key { 'marvin_andrew':
    name   => 'andrew@marvin.local',
    ensure => present,
    key    => $marvin_andrew,
    type   => 'ssh-rsa',
    user   => 'andrew',
  }

  ssh_authorized_key { 'marvin_root':
    name   => 'root@marvin.local',
    ensure => present,
    key    => $marvin_root,
    type   => 'ssh-rsa',
    user   => 'andrew',
  }

  $packages = [ 'ack-grep', 'aptitude', 'curl', 'gnupg2',
                'mg', 'mailutils', 'mosh', 'wget', 'python',
                'python-pip', 'unzip', 'zsh' ]

  ensure_resource('package', $packages, {'ensure' => 'present' })
  ensure_resource('package', 'git', {'ensure' => 'latest'})

  package { 'virtualenvwrapper':
    ensure   => latest,
    provider => pip,
    require  => Package['python-pip']
  }

  Vcsrepo <| provider == git |> {
    require => Package['git']
  }
}
