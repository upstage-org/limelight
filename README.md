# UpStage Limelight
[![Master](https://travis-ci.org/upstage-org/limelight.svg?branch=master)](https://travis-ci.org/upstage-org/limelight)

This is UpStage rebuilt as a Ruby on Rails app with the goal of eventually replacing the UpStage software.

## Dependencies

- Ruby >= 2.4
- Rails >= 5.1


## Usage

The goal is to keep the execution and deployment process as close to the standard Rails methods as possible, IE:

**Once you have Ruby on Rails set up and working**

``` 
$ git pull <REPOSITORY PATH>
$ cd limelight
$ bundle
$ rails db:migrate
$ rails db:seed
$ rails server
```

Examine ```db/seeds.rb``` to retrieve the default login credentials (or change them to suit you)
