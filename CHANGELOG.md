# Change Log

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [0.2.1] - 2020-11-11

### Fixed

- Fix conflict with Sinatra::JSON ([#1](https://github.com/chrismytton/sinatra-github_webhooks/pull/1))

## [0.2.0] - 2015-11-29

### Changed

- Internal refactor to use signature verification logic from `rack-github_webhooks`

## 0.1.0 - 2015-11-29

### Added

- `github_event` method for getting the value of the `X-Github-Event`
- `payload` method which returns a Hash of the request body after verifying the request signature.

[0.2.0]: https://github.com/chrismytton/rack-github_webhooks/compare/v0.1.0...v0.2.0
[0.2.1]: https://github.com/chrismytton/rack-github_webhooks/compare/v0.2.0...v0.2.1
