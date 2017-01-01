require 'test_helper'

# rake test TEST=test/base_test.rb
class FacebookAdsTest < BaseTest
  def test_version
    assert FacebookAds.base_uri.include?('2.8')
  end
end
