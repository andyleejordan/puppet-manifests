# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

# Shortcut for a module from GitHub's boxen organization
def github(name, *args)
  options ||= if args.last.is_a? Hash
    args.last
  else
    {}
  end

  if path = options.delete(:path)
    mod name, :path => path
  else
    version = args.first
    options[:repo] ||= "#{name}"
    mod name, version, :github_tarball => options[:repo]
  end
end

# Shortcut for a module under development
def dev(name, *args)
  mod name, :path => "#{ENV['HOME']}/src/puppet/puppet-#{name}"
end

github "andschwa/puppet-dotfiles",		"0.0.1" tag
github "andschwa/puppet-ghost",			"0.0.2" tag
github "andschwa/puppet-latex",			"0.0.1" tag
github "andschwa/puppet-minecraft",		"2.1.4"
github "andschwa/puppet-mumble",		"0.0.2"
github "andschwa/puppet-person",		"0.0.2"
github "andschwa/puppet-ubuntu",		"0.0.2"
github "arnoudj/puppet-sudo",			"v1.0"
github "attachmentgenie/puppet-module-ufw"
github "jfryman/puppet-nginx",			"v0.0.7"
github "maestrodev/puppet-wget",		"v1.3.1"
github "plainprogrammer/puppet-denyhosts",	"v0.2.0"
github "puppetlabs/puppetlabs-apt",,		"1.4.0"
github "puppetlabs/puppetlabs-concat",		"1.1.0-rc1"
github "puppetlabs/puppetlabs-java",		"1.1.0"
github "puppetlabs/puppetlabs-ntp",		"3.3.0"
github "puppetlabs/puppetlabs-sdtlib",		"4.1.0"
github "puppetlabs/puppetlabs-vcsrepo",		"0.2.0"
github "rtyler/puppet-prosody"
github "spiette/puppet-ssh",			"v0.3.1"
