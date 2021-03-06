# Setup - Ubuntu

## Dependencies
- libpq-dev
- libreadline-dev

## Ruby

If you already have a tool for installing rubies, use that to install version **2.3.0** and skip this section. If you have a dysfunctional `rvm`/`rbenv` setup, uninstall it first. Once you have no existing tool for installing rubies...

Install ruby-dev:

```sh
$ sudo apt-get install ruby-dev
```

Install rbenv:

```sh
# follow these instructions!
> https://github.com/rbenv/rbenv#basic-github-checkout
```

Install the ruby-build rbenv plugin:

```sh
$ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

Install Ruby with rbenv:

```sh
$ rbenv install 2.3.0
```

## Postgres

Install `postgresql`:

Ubuntu 17.04:

```sh
$ sudo apt-get install postgresql-9.6
```

Ubuntu 16.10:

```sh
$ sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
$ wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
$ sudo apt-get update
$ sudo apt-get install postgresql-9.6
```

Ubuntu 16.04 LTS:
```sh
$ sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
$ wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
$ sudo apt-get update
$ sudo apt-get install postgresql-9.6
```

Create the database user for the Rails app:

```sh
$ sudo createuser -s postgres
```

## Redis

You can install Redis as a gem (requires you have the correct ruby installed):

```sh
$ sudo gem install redis
```

Install and start the `redis-server` package by running:

```sh
$ sudo apt-get install redis-server
$ sudo systemctl start redis
```

## PhantomJS

You can install PhantomJS as a gem (requires you have the correct ruby installed):

```sh
$ sudo gem install phantomjs
```
