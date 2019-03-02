# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'date'
require 'sneakers'
require 'sneakers/runner'
require 'json'

Bundler.require :default
Dotenv.load("./.env.#{(ENV['RACK_ENV'] || 'development')}")

require './settings.rb'

## Application Configs
Dir.glob('./config/*.rb') { |file| load file }

## Models
Dir.glob('./models/*.rb') { |file| load file }

## Workers
Dir.glob('./workers/*.rb') { |file| load file }

Sneakers.configure(
  heartbeat: 30,
  amqp: "amqp://#{ENV['RABBIT_MQ_USER']}:#{ENV['RABBIT_MQ_PASS']}@#{ENV['RABBIT_MQ_HOST']}",
  vhost: '/',
  exchange: 'sneakers',
  exchange_type: :direct
)

workers = Sneakers::Runner.new([Workers::MyWorker])
workers.run
