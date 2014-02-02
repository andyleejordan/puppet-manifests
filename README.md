puppet-manifests
================

[![Build Status](https://travis-ci.org/andschwa/puppet-manifests.png?branch=master)](https://travis-ci.org/andschwa/puppet-manifests)

These are my Puppet manifests managing a couple Ubuntu 12.04 LTS
servers. Utilizes
[librarian-puppet](https://github.com/rodjek/librarian-puppet) for
module setup,
[puppet-catalog-test](https://github.com/invadersmustdie/puppet-catalog-test)
for manifest testing, and
[Travis CI](https://travis-ci.org/andschwa/puppet-manifests) for
continuous integration.

## Swap File setup

[DigitalOcean Guide](https://www.digitalocean.com/community/articles/how-to-add-swap-on-ubuntu-12-04)

### Summary:

1. check status `sudo swapon -s`
2. create swapfile `sudo dd if=/dev/zero of=/swapfile bs=1024
   count=512k` ('count' number of blocks of size 'bs' bytes)
3. prepare `sudo mkswap /swapfile`
4. activate `sudo swapon /swapfile`
5. sudo `echo "/swapfile none swap sw 0 0" >> /etc/fstab`
6. set swappiness
    7. `echo 0 | sudo tee /proc/sys/vm/swappiness`
    8. `echo vm.swappiness = 0 | sudo tee -a /etc/sysctl.conf`
9. secure swapfile `sudo chown root:root /swapfile; sudo chmod 0600
   /swapfile`

#### Resize

1. `sudo swapoff -a`
2. continue at step 2 above

## GitLab

### Dependencies

* `nginx` module without conflicting domain
    * SSL needs CSR, bundle scped
    * `usermod -aG git nginx`
* `redis` module
* `postgresql` module
    * patched into (new) init class with
      `create_resources('server::dbs', $dbs = {})`
    * `postgresql::server` class
    * `postgresql::dbs` database with matching user, name, database strings
      (e.g. 'git')
    * patched into `server::db`: password can now be passed as string
      and will get hashed
    * `libpq-dev` needs manual aptitude dependency downgrading
    * patched into client:
    	* `postgresql-client` package conflicted
* `gitlab` module
    * `git_email`
    * `gitlab_(dbtype, dbname, dbuser, dbpwd, domain)`
    * possible manual steps
    	* `bundle update` in git/gitlab
            * rake 10.1.0
        * `bundle install --without development aws test mysql
          --deployment` in git/gitlab
        * `yes yes | bundle exec rake gitlab:setup
          RAILS_ENV=production` in git/gitlab
* `ufw::allows` rules for ports 80, 443
* rbenv module
    * patches into gitlab
        * `rbenv::install`
        * compile `ruby1.9.3-v484` for `$git_user`
        * `rbenv::gem` for `charlock_holmes` instead of gem package
        * `~git/.rbenv/shims` in front of exec_path
