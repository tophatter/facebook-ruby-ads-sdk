require 'test_helper'

# rake test TEST=test/ad_set_test.rb
class AdSetTest < BaseTest
  def test_update
    vcr do
      ad_set = FacebookAds::AdSet.find('6078462927057')
      assert ad_set.update(daily_budget: 149900)
    end
  end
end
