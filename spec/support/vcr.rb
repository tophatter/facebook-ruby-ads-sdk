require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    match_requests_on: [
      :method,
      VCR.request_matchers.uri_without_param(:access_token)
    ]
  }
  c.filter_sensitive_data('<access_token>') do
    ENV['FACEBOOK_ACCESS_TOKEN']
  end
end
