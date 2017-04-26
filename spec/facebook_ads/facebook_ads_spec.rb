require 'spec_helper'

# rspec spec/facebook_ads/facebook_ads_spec.rb
describe FacebookAds do
  describe '#base_uri' do
    it 'is currency v2.8' do
      expect(FacebookAds.base_uri.include?('2.8')).to be_truthy
    end

    it 'can be set to v2.9' do
      FacebookAds.base_uri = 'https://graph.facebook.com/v2.9'
      expect(FacebookAds.base_uri.include?('2.9')).to be_truthy
    end
  end
end
