require 'test_helper'

class AdAccountTest < Minitest::Test
  def setup
    FacebookAds.access_token = 'REDACTED'
    FacebookAds.business_id = 'REDACTED'
  end

  def test_all
    VCR.use_cassette 'ad_account_test_all' do
      accounts = FacebookAds::AdAccount.all
      assert_equal 10, accounts.length
    end
  end
end
