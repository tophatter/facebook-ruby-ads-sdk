require 'spec_helper'

# FACEBOOK_ACCESS_TOKEN=... rspec spec/facebook_ads/ad_campaign_spec.rb
describe FacebookAds::AdCampaign do
  xdescribe '.ad_sets' do
  end

  xdescribe '.create_ad_set' do
  end

  describe '.destroy' do
    it 'creates a new ad campaign', :vcr do
      ad_campaign = FacebookAds::AdCampaign.find('6076262142242')
      expect(ad_campaign.destroy).to be(true)
      ad_campaign = FacebookAds::AdCampaign.find(ad_campaign.id)
      expect(ad_campaign.effective_status).to eq('DELETED')
    end
  end
end
