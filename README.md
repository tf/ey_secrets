# Engine Yard Secrets

[![Gem Version](https://badge.fury.io/rb/ey_secrets.svg)](http://badge.fury.io/rb/ey_secrets)
[![Build Status](https://travis-ci.org/tf/ey_secrets.svg?branch=master)](https://travis-ci.org/tf/ey_secrets)

Manage sensitive configuration files across Engine Yard instances
within a dedicated config app.

## Installation

Add this line to your config app's Gemfile:

    gem 'ey_secrets'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ey_secrets

## Usage

The config app which is used for storing sensitive data is expected to
be hosted within the same parent directory on the same git server as
the software which uses the sensitive data. The sensitive data repo is
expected to carry the name $APP_NAME_config.git if the software repo
is named $APP_NAME.git. For example, if sensitive data can be found at
`git@examplegit.com:companyrepo/software_config.git`, ey_secrets
expects to find the app repo at
`git@examplegit.com:companyrepo/software.git`. You can instead provide
the app's name on Engine Yard using the `-a` option.

The config repo is also expected to contain one folder per Engine Yard
environment, each containing files specific to that environment. For
example:

    staging/
      secrets.env
      config.yml
    production/
      secrets.env
      config.yml

After committing and pushing changes inside the config repository, run:

    $ cd my_project
    $ eysecrets update -e production

Now all files of the form `production/*` are copied to
`/data/<app_name>/shared/config` on all instances of the production
environment. The command also restarts passenger and the monit group
`<app_name>_resque`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
