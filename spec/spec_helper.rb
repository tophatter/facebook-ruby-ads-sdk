require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

require 'support/rack_facebook'
RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /graph.facebook.com/).to_rack(RackFacebook)
  end
end

require 'facebook_ads'
FacebookAds.access_token = 'FAKE_ACCESS_TOKEN'

# The COVERALLS_REPO_TOKEN is set in the project setting for TravisCI.
# https://travis-ci.org/cte/facebook-ads-sdk-ruby/settings
# https://coveralls.io/github/cte/facebook-ads-sdk-ruby
if ENV['COVERALLS_PUSH']
  puts "Read #{ENV['COVERALLS_REPO_TOKEN'].length} character COVERALLS_REPO_TOKEN from ENV."
  require 'coveralls'
  Coveralls.wear!
end
