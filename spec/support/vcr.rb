# frozen_string_literal: true

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    match_requests_on: [
      :method,
      VCR.request_matchers.uri_without_param(:access_token, :app_secret)
    ]
  }
  c.filter_sensitive_data('<access_token>') do
    FacebookAds.access_token
  end
  c.filter_sensitive_data('<appsecret_proof>') do
    FacebookAds.appsecret_proof
  end
  c.filter_sensitive_data('<api_version>') do
    FacebookAds.api_version
  end
end
