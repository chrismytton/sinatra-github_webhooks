ENV['RACK_ENV'] = 'test'
require 'simplecov'
SimpleCov.start if ENV['COVERAGE']

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sinatra/github_webhooks'

require 'minitest/autorun'
require 'rack/test'
