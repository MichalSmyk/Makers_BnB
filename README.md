### ActiveRecord Local Project Setup

1. Create databases (makersbnb-development, makersbnb-test)
2. Run command:

```
bundle install
```
3. Run command:

```
rake db:migrate
```
4. Run command:

```
rake db:seed (once we have written the seeds!)
```
5. Migrate and seed the test database
```
rake RACK_ENV="test" db:migrate
rake RACK_ENV="test" db:seed
```



# MakersBnB Project Seed

This repo contains the seed codebase for the MakersBnB project in Ruby (using Sinatra and RSpec).

Someone in your team should fork this seed repo to their Github account. Everyone in the team should then clone this fork to their local machine to work on it.

## Setup

```bash
# Install gems
bundle install

# Run the tests
rspec

# Run the server (better to do this in a separate terminal).
rackup
```
