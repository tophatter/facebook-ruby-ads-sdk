# frozen_string_literal: true

require 'spec_helper'

# FACEBOOK_ACCESS_TOKEN=... rspec spec/facebook_ads/ad_campaign_spec.rb
describe FacebookAds::AdCampaign do
  let(:campaign) do
    FacebookAds::AdCampaign.new(
      id: '120330000008134915',
      account_id: '10152335766987003',
      buying_type: 'AUCTION',
      can_use_spend_cap: true,
      configured_status: 'PAUSED',
      created_time: '2017-08-25T15:47:51-0700',
      effective_status: 'PAUSED',
      name: 'Test Campaign',
      objective: 'CONVERSIONS',
      start_time: '1969-12-31T15:59:59-0800',
      updated_time: '2017-08-25T15:47:51-0700'
    )
  end

  let(:targeting) do
    targeting = FacebookAds::AdTargeting.new
    targeting.genders = [FacebookAds::AdTargeting::WOMEN]
    targeting.age_min = 29
    targeting.age_max = 65
    targeting.countries = ['US']
    targeting.user_os = [FacebookAds::AdTargeting::ANDROID_OS]
    targeting.user_device = FacebookAds::AdTargeting::ANDROID_DEVICES
    targeting.app_install_state = FacebookAds::AdTargeting::NOT_INSTALLED
    targeting
  end

  xdescribe '.ad_sets' do
  end

  describe '.create_ad_set' do
    it 'creates_valid_ad_set', :vcr do
      ad_set = campaign.create_ad_set(
        name: 'Test Ad Set',
        targeting: targeting,
        optimization_goal: 'IMPRESSIONS',
        daily_budget: 500, # This is in cents, so the daily budget here is $5.
        billing_event: 'IMPRESSIONS',
        status: 'PAUSED',
        bid_strategy: 'LOWEST_COST_WITHOUT_CAP'
      )
      expect(ad_set.id).to eq('120330000008135715')
    end
  end

  describe '.destroy' do
    it 'sets effective status to deleted', :vcr do
      ad_campaign = FacebookAds::AdCampaign.find('6076262142242')
      expect(ad_campaign.destroy).to be(true)
      ad_campaign = FacebookAds::AdCampaign.find(ad_campaign.id)
      expect(ad_campaign.effective_status).to eq('DELETED')
    end
  end
end
