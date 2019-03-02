# frozen_string_literal: true

env = (ENV['RACK_ENV'] || :development)
Mongoid.load!('./config/mongoid.yml', env)
