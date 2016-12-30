require 'test_helper'

class AdAccountTest < Minitest::Test
  def setup
    FacebookAds.access_token = File.read('test_access_token').squish
    FacebookAds.business_id = File.read('test_business_id').squish
    # FacebookAds.logger = Logger.new(STDOUT)
    # FacebookAds.logger.level = Logger::Severity::DEBUG
  end

  def test_all
    VCR.use_cassette 'ad_account_test_all' do
      accounts = FacebookAds::AdAccount.all
      assert_equal 10, accounts.length
    end
  end
end
