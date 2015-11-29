# Sinatra::GithubWebhooks [![Build Status](https://travis-ci.org/chrismytton/sinatra-github_webhooks.svg?branch=master)](https://travis-ci.org/chrismytton/sinatra-github_webhooks)

Helper methods for receiving [GitHub webhooks](https://developer.github.com/webhooks/) with Sinatra.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sinatra-github_webhooks'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sinatra-github_webhooks

## Usage

This module provides two methods to use when handling GitHub webhook requests:

- `github_event` This is the value of the `X-Github-Event` header in the request, e.g. `pull_request`
- `payload`      This is a Hash of the request body after being parsed.

If you provided a webhook secret when you configured your GitHub webhook you can ensure the request comes from GitHub by setting `github_webhook_secret`.

Using this extension in classic style Sinatra apps is as simple as requiring the extension, optionally defining `github_webhook_secret` for verifying webhooks, and using the methods:

```ruby
require 'sinatra'
require 'sinatra/github_webhooks'

configure do
  set :github_webhook_secret, 's3cret'
end

get '/event_handler' do
  github_event  # Value of the X-Github-Event header
  payload       # Hash of the request body

  if github_event == 'pull_request' && payload['action'] == 'opened'
    # Do something in response to a newly opened Pull Request.
  end
  'ok'
end
```

Sinatra::Base subclasses need to require and include the module explicitly using the `helpers` method:

```ruby
require 'sinatra/base'
require 'sinatra/github_webhooks'

class WebhookApp < Sinatra::Base
  helpers Sinatra::GithubWebhooks

  configure do
    set :github_webhook_secret, 's3cret'
  end

  get '/event_handler' do
    github_event  # Value of the X-Github-Event header
    payload       # Hash of the request body

    if github_event == 'pull_request' && payload['action'] == 'opened'
      # Do something in response to a newly opened Pull Request.
    end
    'ok'
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chrismytton/sinatra-github_webhooks.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
