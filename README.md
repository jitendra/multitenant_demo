## Setup

```console
$ bundle install
$ bundle exec rails db:migrate
$ bundle exec rails server
```

## Test

```console
$ bundle exec rspec
```

## Data reset and sample data creation

```console
$ bundle exec rails db:reset    # Data reset
$ bundle exec rails db:sample_data # Create sample data
```

## Credit
I used https://github.com/toshimaru/RailsTwitterClone as base code and configured in this repo for Multitenant.