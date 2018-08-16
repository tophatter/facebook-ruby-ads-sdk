# frozen_string_literal: true

# Force the request headers to only accept JSON, and disable gzip.
# This makes our VCR cassettes human readable.
module RestClient
  class Request
    def default_headers
      { accept: 'application/json', accept_encoding: 'identity' }
    end
  end
end
