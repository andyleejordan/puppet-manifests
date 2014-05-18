# site.pp
node 'vagrant' inherits default {}

node 'krikkit.schwartzmeyer.com' inherits default {}

node 'slartibartfast.schwartzmeyer.us' inherits default {}

node default {
  # hiera ssh keys
  create_resources('ssh_authorized_key', hiera_hash('ssh_keys', {}), hiera_hash('ssh_key_defaults', {}))

  # hiera mounts
  create_resources('file', hiera_hash('mount_points', {}), {ensure => directory})
  create_resources('mount', hiera_hash('mounts', {}), hiera_hash('mount_defaults', {}))

  # hiera vcsrepos
  create_resources('vcsrepo', hiera_hash('vcsrepos', {}))

  # hiera packages
  ensure_packages(hiera_array('packages', []))

  # common package dependencies
  ensure_packages(['git', 'python', 'python-pip'])

  $pip_packages = hiera_array('pip_packages')
  package { $pip_packages:
    ensure   => latest,
    provider => pip,
    require  => Package['python-pip']
  }

  Vcsrepo <| provider == git |> {
    require => Package['git']
  }
}

hiera_include('classes')
