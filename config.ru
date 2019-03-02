# frozen_string_literal: true

require 'bundler'
require 'json'

Bundler.require :default
Dotenv.load("./.env.#{(ENV['RACK_ENV'] || 'development')}")

# Main application files
require './init.rb'

## CORS
require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get post options put delete patch]
  end
end

run Rack::Cascade.new [Application::API]

## to run, use the following command in development
## bundle exec rackup
