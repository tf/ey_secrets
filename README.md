# Engine Yard Secrets

Manage sensible configuration files accross Engine Yard instances.

## Installation

Add this line to your application's Gemfile:

    gem 'ey_secrets'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ey_secrets

## Usage

The repository is expected to contain one folder per Engine Yard
environment, each containing files with `.env` extension. For example:

    staging/
      secrets.env
    production/
      secrets.env

After commiting and pushing changes inside the config repository, run:

    $ cd my_project
    $ eysecrets update -e production
    
Now all files of the form `production/*.env` are copied
to `/data/<app_name>/shared/config` on all instances of the production
environment. The command also restarts passenger and the monit group
`<app_name>_resque`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
