# frozen_string_literal: true

require 'sinatra/github_webhooks/version'

require 'sinatra/base'
require 'rack/github_webhooks'
require 'json'

module Sinatra
  module GithubWebhooks
    def github_event
      request.env['HTTP_X_GITHUB_EVENT']
    end

    def payload
      JSON.parse(payload_body)
    end

    private

    def payload_body
      request.body.rewind
      payload_body = request.body.read
      verify_signature(payload_body)
      payload_body
    end

    # Taken from https://developer.github.com/webhooks/securing/
    def verify_signature(payload_body)
      unless settings.respond_to?(:github_webhook_secret)
        logger.warn 'No :github_webhook_secret setting found, skipping signature verification'
        return
      end
      signature = Rack::GithubWebhooks::Signature.new(
        settings.github_webhook_secret,
        request.env['HTTP_X_HUB_SIGNATURE'],
        payload_body
      )
      return halt 500, "Signatures didn't match!" unless signature.valid?
    end
  end

  helpers GithubWebhooks
end
