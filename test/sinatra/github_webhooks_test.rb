require 'test_helper'

class GithubWebhookHandlerApp < Sinatra::Base
  helpers Sinatra::GithubWebhooks

  set :github_webhook_secret, 's3cret'

  post '/github_event' do
    github_event
  end

  post '/event_handler' do
    payload['action']
  end
end

class GithubWebhookHandlerNoSecretApp < Sinatra::Base
  helpers Sinatra::GithubWebhooks

  post '/event_handler' do
    payload['action']
  end
end

class SinatraGithubWebhooksTest < Minitest::Test
  include Rack::Test::Methods

  HMAC_DIGEST = OpenSSL::Digest.new('sha1')

  def body_signature(body)
    'sha1=' + OpenSSL::HMAC.hexdigest(
      HMAC_DIGEST,
      's3cret',
      body
    )
  end

  def app
    @app ||= GithubWebhookHandlerApp
  end

  def test_that_it_has_a_version_number
    refute_nil ::Sinatra::GithubWebhooks::VERSION
  end

  def test_github_event
    post '/github_event', {}, 'HTTP_X_GITHUB_EVENT' => 'pull_request'
    assert_equal 'pull_request', last_response.body
    post '/github_event', {}, 'HTTP_X_GITHUB_EVENT' => 'push'
    assert_equal 'push', last_response.body
  end

  def test_invalid_signature
    post '/event_handler',
      '{}',
      'HTTP_X_HUB_SIGNATURE' => 'sha1=invalid'
    assert_equal 500, last_response.status
    assert_equal "Signatures didn't match!", last_response.body
  end

  def test_valid_signature
    body = '{"action": "opened"}'
    post '/event_handler', body, 'HTTP_X_HUB_SIGNATURE' => body_signature(body)
    assert_equal 200, last_response.status
    assert_equal 'opened', last_response.body
  end

  def test_missing_secret
    @app = GithubWebhookHandlerNoSecretApp
    body = '{"action": "opened"}'
    post '/event_handler', body, 'HTTP_X_HUB_SIGNATURE' => body_signature(body)
    assert_equal 200, last_response.status
    assert_equal 'opened', last_response.body
    @app = GithubWebhookHandlerApp
  end
end
