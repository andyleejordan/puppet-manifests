# -*-Ruby-*-
# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

forge "http://forge.puppetlabs.com"

# Shortcut for a module from andschwa's GitHub account
def github(user, name, *args)
  options ||= if args.last.is_a? Hash
                args.last
              else
                {}
              end
  if path = options.delete(:path)
    mod user + '/' + name, :path => path
  else
    options[:repo] ||= "git://github.com/#{user}/puppet-#{name}.git"
    options[:ref] ||= if not options.has_key?('ref')
                        'master'
                      end
    mod user + '/' + name, :git => options[:repo], :ref => options[:ref]
  end
end

# Shortcut for a module under development
def dev(name)
  mod 'dev/' + name, :path => "#{ENV['HOME']}/src/puppet/puppet-#{name}"
end

# GitHub andschwa/modules
github 'andschwa', 'dovecot', :ref => 'development'
github 'andschwa', 'gitlab', :ref => 'development'
github 'andschwa', 'latex'
github 'andschwa', 'person'
github 'andschwa', 'postfix'
github 'andschwa', 'postgresql', :ref => 'client-package-hotfix'
github 'andschwa', 'prosody'
github 'andschwa', 'redis'
github 'andschwa', 'ubuntu'
github 'andschwa', 'ufw', :ref => 'development'

# Forge modules
mod 'alup/rbenv',          '~> 1.2.0'
mod 'andschwa/ghost',      '~> 0.1.3'
mod 'andschwa/minecraft',  '~> 2.1.6'
mod 'andschwa/mumble',     '~> 0.0.3'
mod 'arnoudj/sudo',        '~> 1.1.1'
mod 'attachmentgenie/ssh', '~> 1.2.1'
mod 'fsalum/redis',        '~> 0.0.9'
mod 'jfryman/nginx',       '~> 0.0.7'
mod 'maestrodev/wget',     '~> 1.3.1'
mod 'mjhas/amavis',        '~> 0.0.2'
mod 'puppetlabs/apt',      '~> 1.4.0'
mod 'puppetlabs/concat',   '~> 1.1.0'
mod 'puppetlabs/java',     '~> 1.0.1'
mod 'puppetlabs/ntp',      '~> 3.0.1'
mod 'puppetlabs/stdlib',   '~> 4.1.0'
mod 'puppetlabs/vcsrepo',  '~> 0.2.0'
mod 'thias/vsftpd',        '~> 0.2.0'
