# site.pp
node 'vagrant' inherits default {
  include profile::backup
  include profile::chat
  include profile::ghost
  include profile::ftp
  include profile::logging
  include profile::mail
  include profile::web
}

node 'krikkit.schwartzmeyer.com' inherits default {
  include profile::backup
  include profile::chat
  include profile::firewall
  include profile::ftp
  include profile::irc_bouncer
  include profile::ghost
  include profile::gitlab
  include profile::logging
  include profile::mail
  include profile::web
}

node 'slartibartfast.schwartzmeyer.us' inherits default {
  include profile::backup
  include profile::firewall
  include profile::minecraft
}

node default {
  include profile
}
