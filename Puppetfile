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
  mod 'dev/' + name, :path => "#{ENV['HOME']}/Documents/src/puppet-modules/#{name}"
end

# GitHub andschwa/modules
github 'andschwa', 'dovecot',    :ref => 'production'
github 'andschwa', 'ghost',      :ref => 'dev'
github 'andschwa', 'gitlab',     :ref => 'production'
github 'andschwa', 'latex'
github 'andschwa', 'person'
github 'andschwa', 'postfix',    :ref => 'production'
github 'andschwa', 'papertrail'
github 'andschwa', 'postgresql', :ref => 'production'
github 'andschwa', 'profile'
github 'andschwa', 'prosody',    :ref => 'production'
github 'andschwa', 'redis'
github 'andschwa', 'ubuntu'

# Forge modules
mod 'alup/rbenv',          '~> 1.2.0'
mod 'andschwa/minecraft',  '~> 2.1.6'
mod 'andschwa/mumble',     '~> 0.0.3'
mod 'arnoudj/sudo',        '~> 1.1.1'
mod 'attachmentgenie/ssh', '~> 1.2.1'
mod 'attachmentgenie/ufw', '~> 1.4.9'
mod 'fsalum/redis',        '~> 0.0.9'
mod 'jfryman/nginx',       '~> 0.0.7'
mod 'mjhas/amavis',        '~> 0.0.2'
mod 'puppetlabs/apt',      '~> 1.4.0'
mod 'puppetlabs/git',      '~> 0.0.3'
mod 'puppetlabs/concat',   '~> 1.1.0'
mod 'puppetlabs/java',     '~> 1.0.1'
mod 'puppetlabs/ntp',      '~> 3.0.1'
mod 'puppetlabs/stdlib',   '~> 4.1.0'
mod 'puppetlabs/vcsrepo',  '~> 0.2.0'
mod 'thias/vsftpd',        '~> 0.2.0'
