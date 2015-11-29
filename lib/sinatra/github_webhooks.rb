require 'sinatra/github_webhooks/version'

require 'sinatra/base'
require 'openssl'
require 'json'

module Sinatra
  module GithubWebhooks
    HMAC_DIGEST = OpenSSL::Digest.new('sha1')

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
        logger.warn "No :github_webhook_secret setting found, skipping signature verification"
        return
      end
      signature = 'sha1=' + OpenSSL::HMAC.hexdigest(
        HMAC_DIGEST,
        settings.github_webhook_secret,
        payload_body
      )
      signatures_match = Rack::Utils.secure_compare(
        signature,
        request.env['HTTP_X_HUB_SIGNATURE']
      )
      return halt 500, "Signatures didn't match!" unless signatures_match
    end
  end

  helpers GithubWebhooks
end
