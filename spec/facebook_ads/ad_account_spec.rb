require 'spec_helper'

# FACEBOOK_ACCESS_TOKEN=... rspec spec/facebook_ads/ad_account_spec.rb
describe FacebookAds::AdAccount do
  let(:account) do
    FacebookAds::AdAccount.new(
      id: 'act_10152335766987003',
      account_id: '10152335766987003',
      account_status: 1,
      age: 466.0,
      created_time: '2014-10-24T14:38:31-0700',
      currency: 'USD',
      name: 'Chris Estreich'
    )
  end

  describe '#all' do
    it 'lists all accounts', :vcr do
      accounts = FacebookAds::AdAccount.all
      verify(format: :json) { JSON.dump(accounts) }
    end
  end

  describe '#find_by' do
    it 'finds a specific account', :vcr do
      account = FacebookAds::AdAccount.find_by(name: 'iOS')
      verify(format: :json) { JSON.dump(account) }
    end
  end

  describe '.ad_campaigns' do
    it 'lists campaigns', :vcr do
      ad_campaigns = account.ad_campaigns
      verify(format: :json) { JSON.dump(ad_campaigns) }
    end
  end

  describe '.create_ad_campaign' do
    it 'creates a new ad campaign', :vcr do
      ad_campaign = account.create_ad_campaign(name: 'Test', objective: 'MOBILE_APP_INSTALLS')
      verify(format: :json) { JSON.dump(ad_campaign) }
    end
  end

  describe '.ad_images' do
    it 'lists images', :vcr do
      ad_images = account.ad_images(hashes: %w[d8fc613662fb5ef6cf5fb9d1fe779315])
      verify(format: :json) { JSON.dump(ad_images) }
      expect(ad_images.first.hash).to eq('d8fc613662fb5ef6cf5fb9d1fe779315')
    end
  end

  describe '.create_ad_images' do
    it 'creates an image', :vcr do
      ad_images = account.create_ad_images(['https://img0.etsystatic.com/108/1/13006112/il_570xN.1047856494_l2gp.jpg'])
      verify(format: :json) { JSON.dump(ad_images) }
      expect(ad_images.first.hash).to eq('d8fc613662fb5ef6cf5fb9d1fe779315')
    end
  end

  describe '.ad_creatives' do
    it 'lists creatives', :vcr do
      ad_creatives = account.ad_creatives
      verify(format: :json) { JSON.dump(ad_creatives) }
    end
  end

  describe '.ad_sets' do
    it 'lists ad sets', :vcr do
      ad_sets = account.ad_sets
      verify(format: :json) { JSON.dump(ad_sets) }
    end
  end

  describe '.ads' do
    it 'lists ads', :vcr do
      ads = account.ads
      verify(format: :json) { JSON.dump(ads) }
    end
  end

  describe '.reach_estimate' do
    it 'estimates the reach of a targeting spec', :vcr do
      targeting = FacebookAds::AdTargeting.new
      targeting.genders = [FacebookAds::AdTargeting::WOMEN]
      targeting.age_min = 18
      targeting.age_max = 20
      targeting.countries = ['US']
      reach = account.reach_estimate(targeting: targeting, optimization_goal: 'OFFSITE_CONVERSIONS')
      verify(format: :json) { JSON.dump(reach) }
    end
  end
end
