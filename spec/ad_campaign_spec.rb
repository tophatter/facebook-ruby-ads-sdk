require 'spec_helper'

describe FacebookAds::AdCampaign do

  describe '.find' do
    it 'Finds an AdCampaign instance' do
      id = '6057330925170'
      campaign = FacebookAds::AdCampaign.find(id)
      expect(campaign.id).to eql(id)
    end
  end

end
