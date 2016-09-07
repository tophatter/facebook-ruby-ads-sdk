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

require 'coveralls'
Coveralls.wear!
