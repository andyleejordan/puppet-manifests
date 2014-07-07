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

## Hiera

I use Hiera because, with the `deep_merge` gem installed, and the
`deeper` merge behavior, Puppet's built-in function `create_resources`
becomes incredibly handy for merging together and creating resources
from across multiple YAML files (e.g. hostname, operating system,
release). I finally figured out an easier way to test, and it looks
like this:

    hiera -h -d -c test/hiera.yaml ubuntu::sources ::hostname=krikkit ::operatingsystem=Ubuntu ::operatingsystemrelease=12.04

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

## vsftpd

Manual steps needed to setup virtual users:

* Install `db-util`
* Create user/pass alternating list at `/etc/vsftpd/virtual_users`
* `db_load -T -t hash -f virtual_users virtual_users.db`
* `chmod 600 virtual_users.db`
* `chown -R ftp:ftp /var/www/virtual`
* Set `/etc/pam.d/vsftpd` to:
```
auth    required        pam_userdb.so db=/etc/vsftpd/virtual_users
account required        pam_userdb.so db=/etc/vsftpd/virtual_users
session required        pam_loginuid.so
```

## OpenSSL

### Key and Cert Generation

[DigitalOcean Guide](https://www.digitalocean.com/community/articles/how-to-create-a-ssl-certificate-on-nginx-for-ubuntu-12-04)

```
openssl req -new -newkey rsa:2048 -nodes -keyout domain.key -out domain.csr
```
### Certificate Bundle

[Comodo](https://support.comodo.com/index.php?_a=viewarticle&_m=knowledgebase&kbarticleid=1365)

```
cat www_yourdomain_com.crt ComodoHigh-AssuranceSecureServerCA.crt AddTrustExternalCARoot.crt >> ssl-bundle.crt
```

## Postfix

### Aliases

These are sane aliases from the
[DigitalOcean guide](https://www.digitalocean.com/community/articles/how-to-set-up-a-postfix-e-mail-server-with-dovecot),
with root being forwarded to my email.

```
mailer-daemon: postmaster
postmaster: root
nobody: root
hostmaster: root
webmaster: root
www: root
ftp: root
abuse: root
root: andrew
```

### Amavis

Setting up Amavis meant following the included readme for Postfix; it
is quite detailed and worked perfectly. Michael's modules installed
the necessary packages for Amavis with SpamAssassin. The latter also
has an integration with Postfix
[guide](https://wiki.apache.org/spamassassin/IntegratedInPostfixWithAmavis).

#### Pyzor

The latest version of Pyzor should be installed from the Python
package repositories, as the Ubuntu/Debian package is woefully out of
date. This is done by Puppet for my mailhost.

I (sadly) do not have Spamassassin Puppetized further than
installation, so for setup, add the following lines (from the
[Wiki](https://wiki.apache.org/spamassassin/UsingPyzor)):

```
# pyzor
use_pyzor 1
pyzor_path /usr/local/bin/pyzor
pyzor_options --homedir /etc/mail/spamassassin
```

Then test with `echo "test" | spamassassin -D pyzor 2>&1 | less`.

## LogWatch

Setting up [LogWatch](https://sourceforge.net/projects/logwatch/) is
as simple as installing the package. DigitalOcean has a
[guide](https://www.digitalocean.com/community/articles/how-to-install-and-use-logwatch-log-analyzer-and-reporter-on-a-vps)
for configuration; however, the defaults are practically perfect.

There is a
[reported bug](https://bugs.launchpad.net/ubuntu/+source/logwatch/+bug/1058760)
with the Dovecot service, resulting in many unmatched entries.

After backing up `/usr/share/logwatch/scripts/services/dovecot`, apply
the patch via `curl
https://launchpadlibrarian.net/117816434/dovecot.patch | sudo patch`.

## Tiger

[Tiger](http://www.nongnu.org/tiger/) is the Unix security audit and
intrusion detection tool, and is "setup" by installing the
package. The default configuration enables periodic audit emails. I
have found that I also needed to add the following lines to
`/etc/tiger/tiger.ignore`:

```
The process `smtpd' is listening on socket 25 \(TCP on every interface\) is run by postfix\.
The process `imap-login' is listening on socket (143|993) \(TCP on every interface\) is run by dovenull\.
The process `avahi-daemon' is listening on socket \d+ \(UDP on every interface\) is run by avahi\.
```

This ignores frequently repeated messages about `smtpd`, `imap-login`,
and `avahi-daemon`.
