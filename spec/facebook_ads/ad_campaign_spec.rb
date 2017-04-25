require 'spec_helper'

describe FacebookAds::AdCampaign do
  # def test_list
  #   vcr do
  #     account = FacebookAds::AdAccount.find_by(name: 'Ruby')
  #     ad_campaigns = account.ad_campaigns
  #     ad_campaign = ad_campaigns.first
  #     assert_equal '23842540417890562', ad_campaign.id
  #     assert_equal '1115226431853975', ad_campaign.account_id
  #     assert_equal 'AUCTION', ad_campaign.buying_type
  #     assert_equal true, ad_campaign.can_use_spend_cap
  #     assert_equal 'ACTIVE', ad_campaign.configured_status
  #     assert_equal 'ACTIVE', ad_campaign.effective_status
  #     assert_equal 'iOS App installs', ad_campaign.name
  #     assert_equal 'MOBILE_APP_INSTALLS', ad_campaign.objective
  #   end
  # end
  #
  # def test_create
  #   vcr do
  #     account = FacebookAds::AdAccount.find_by(name: 'ReFuel4')
  #     ad_campaign = account.create_ad_campaign(name: 'Test', objective: 'MOBILE_APP_INSTALLS')
  #     assert_equal 'Test', ad_campaign.name
  #     assert_equal 'MOBILE_APP_INSTALLS', ad_campaign.objective
  #     assert_equal true, ad_campaign.destroy
  #     ad_campaign = FacebookAds::AdCampaign.find(ad_campaign.id)
  #     assert_equal 'DELETED', ad_campaign.effective_status
  #   end
  # end
end
