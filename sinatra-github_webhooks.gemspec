# frozen_string_literal: true

require_relative 'lib/sinatra/github_webhooks/version'

Gem::Specification.new do |spec|
  spec.name          = 'sinatra-github_webhooks'
  spec.version       = Sinatra::GithubWebhooks::VERSION
  spec.authors       = ['Chris Mytton']
  spec.email         = ['chrismytton@gmail.com']

  spec.summary       = 'Helper methods for receiving GitHub webhooks with Sinatra'
  spec.homepage      = 'https://github.com/chrismytton/sinatra-github_webhooks'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rack-github_webhooks', '>= 0.3.0'
  spec.add_dependency 'sinatra'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov'
end
