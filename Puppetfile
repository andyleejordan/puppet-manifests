# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

forge "http://forge.puppetlabs.com"

# Shortcut for a module from GitHub's boxen organization
def andschwa(name, *args)
  options ||= if args.last.is_a? Hash
                args.last
              else
                {}
              end
  if path = options.delete(:path)
    mod name, :path => path
  else
    options[:repo] ||= "git://github.com/andschwa/puppet-#{name}.git"
    mod name, :git => options[:repo]
  end
end

# Shortcut for a module under development
def dev(name, *args)
  mod name, :path => "#{ENV['HOME']}/src/puppet/puppet-#{name}"
end

# GitHub andschwa/modules
andschwa "dotfiles"
andschwa "latex"
andschwa "person"
andschwa "prosody"
andschwa "ubuntu"

# Forge modules
mod "andschwa/ghost",            "0.0.2"
mod "andschwa/minecraft",        "2.1.4"
mod "andschwa/mumble",           "0.0.2"
mod "arnoudj/sudo",              "1.1.1"
mod "attachmentgenie/ufw",       "1.4.6"
mod "jfryman/nginx",             "0.0.7"
mod "maestrodev/wget",           "1.3.1"
mod "plainprogrammer/denyhosts", "0.4.0"
mod "puppetlabs/apt",            "1.4.0"
mod "puppetlabs/concat",         "1.1.0"
mod "puppetlabs/java",           "1.0.1"
mod "puppetlabs/ntp",            "3.0.1"
mod "puppetlabs/stdlib",         "4.1.0"
mod "puppetlabs/vcsrepo",        "0.2.0"
mod "spiette/ssh",               "0.3.1"
