# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'
require 'simplecov'
SimpleCov.start if ENV['COVERAGE']

require_relative '../lib/sinatra/github_webhooks'

require 'minitest/autorun'
require 'rack/test'
