require 'spec_helper'

# FACEBOOK_ACCESS_TOKEN=... rspec spec/facebook_ads/ad_campaign_spec.rb
describe FacebookAds::AdCampaign do
  describe '.create' do
    it 'creates a new ad campaign', :vcr do
      account = FacebookAds::AdAccount.find_by(name: 'Chris Estreich')
      ad_campaign = account.create_ad_campaign(name: 'Test', objective: 'MOBILE_APP_INSTALLS')
      verify(format: :json) { JSON.dump(ad_campaign) }
    end
  end

  describe '.destroy' do
    it 'creates a new ad campaign', :vcr do
      account = FacebookAds::AdAccount.find_by(name: 'Chris Estreich')
      ad_campaign = account.create_ad_campaign(name: 'Test', objective: 'MOBILE_APP_INSTALLS')
      expect(ad_campaign.destroy).to be(true)
      ad_campaign = FacebookAds::AdCampaign.find(ad_campaign.id)
      expect(ad_campaign.effective_status).to eq('DELETED')
    end
  end
end
