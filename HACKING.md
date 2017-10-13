# Hacking

## Table of Contents

- [Setup](#setup-)
- [Development](#development-)
- [Testing](#testing-)
- [Hosting / Deployment](#hosting--deployment-)
- [Architecture](#architecture-)

## Setup [↑](#table-of-contents)

A quick foreword (**please don't ignore this**):
- If you don't use a ruby version manager like rbenv/rvm, please [install one now](https://github.com/rbenv/rbenv)
- Some packages need to be installed using your system's package manager
- You can find some platform-specific documentation for [Mac](wiki/osx.md) and [Ubuntu](wiki/ubuntu.md)

Install the necessary global dependencies.
- readline -> **must** be installed before Ruby
- ruby (2.3.0) -> [installation](https://github.com/rbenv/rbenv)
- bundler -> `gem install bundler`
- foreman -> `gem install foreman`
- postgresql
- redis
- phantomjs

Copy over the development .env file:

```sh
$ cp .env.sample .env
```

Then install local dependencies with bundler:

```sh
$ bundle
```

## Development [↑](#table-of-contents)

Make **sure** Postgres and Redis are started, and then start the server with:

```sh
$ foreman start
```

The first time you run the application, you'll also need to setup the database (if you make any database changes you can also run this again):

```sh
$ rails db:reset
```

You can use the rails console to explore the database through using [ActiveRecord](http://guides.rubyonrails.org/active_record_querying.html):

```sh
$ rails console
```

You can use the interactive debugger [pry](http://pryrepl.org/) to set breakpoints and explore the code at runtime:

```ruby
binding.pry
```

Before pushing anything, please make sure to run the linter and tests using `rake`.

```sh
$ rake
$ rubocop -a # if rubocop fails, this fixes any possible linter issues
```

## Testing [↑](#table-of-contents)

Tests are written using [rspec](http://www.relishapp.com/rspec/rspec-expectations/v/3-5/docs), and live under the `spec` directory. Please add specs for any new features.

Run all the specs using the rake task:

```sh
$ rails spec
```

Or run individual spec files using the `rspec` directly:

```sh
$ rspec spec/jobs/import_hearings_job_spec.rb
```

Many editors also have a rails-rspec plugin that will let you run specs from your editor, run just the example under your cursor, etc. If you're into that kind of thing.

## Hosting / Deployment [↑](#table-of-contents)

The application is hosted on [Heroku](https://dashboard.heroku.com/apps/legislated). When a commit is pushed to master, it is automatically deployed to our staging server. When a commit is pushed to production, it is automatically deployed to our production server.

You can interface with the remote apps, their databases, etc. by installing the Heroku [toolbelt](https://devcenter.heroku.com/articles/heroku-cli#download-and-install). However, in order to access our app, you'll need to ask somebody to make you a collaborator.

Once that's set up, you can connect a Rails console to explore the Heroku app's data:

```sh
$ heroku login # enter your credentials
$ heroku console -a legislated-staging
```

## Architecture [↑](#table-of-contents)

If you've never worked with some of the technologies on this project, it may be worth reading up on them. Here's a rough breakdown the application architecture and major technologies:

#### [Web Server (Rails)](http://guides.rubyonrails.org/)

Rails is a web-application framework, and we use it so serve our API, interact with the database, etc. If you've never worked with it, their documentation is a good place to start.

#### [API (GraphQL)](wiki/api.md)

Our API is built using GraphQL, a query language that is an alternative to REST. It offers a lot of flexibility to clients by allowing them to specify the exact data fields of the response. It's also simple to implement on Rails side. See the link for more info.

#### [Data Import (Sidekiq, Capybara)](wiki/import.md)

We use Sidekiq to scrape data nightly from Illinois government websites and throw it in our database. Sidekiq provides a queueing system, built on top of Redis, for running the import jobs in the background.
