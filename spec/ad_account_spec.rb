require 'spec_helper'

describe FacebookAds::AdAccount do
  describe '.all' do
    it 'Lists all AdAccount instances' do
      accounts = FacebookAds::AdAccount.all
      expect(accounts.length).to eql(7)
    end
  end

  describe '.find' do
    it 'Finds an AdAccount by id' do
      id = 'act_861827983860489'
      account = FacebookAds::AdAccount.find(id)
      expect(account.id).to eql(id)
    end
  end

  describe '.find_by' do
    it 'Finds an AdAccount by name' do
      name = 'Android'
      account = FacebookAds::AdAccount.find_by(name: name)
      expect(account.name).to eql(name)
    end
  end

  describe '.ad_campaigns' do
    it 'Lists AdCampaign instances' do
      ad_campaigns = account.ad_campaigns
      ad_campaign = ad_campaigns.first
      expect(ad_campaign.account_id).to eql(account_id)
    end
  end

  describe '.ad_images' do
    it 'Lists AdImage instances' do
      ad_images = account.ad_images
      ad_image = ad_images.first
      expect(ad_image.account_id).to eql(account_id)
    end
  end

  describe '.ad_creatives' do
    it 'Lists AdCreative instances' do
      ad_creatives = account.ad_creatives
      ad_creative = ad_creatives.first
      expect(ad_creative.id).to eql('6057824295570')
    end
  end

  describe '.ad_sets' do
    it 'Lists AdSet instances' do
      ad_sets = account.ad_sets
      ad_set = ad_sets.first
      expect(ad_set.account_id).to eql(account_id)
    end
  end

  describe '.ads' do
    it 'Lists Ad instances' do
      ads = account.ads
      ad = ads.first
      expect(ad.account_id).to eql(account_id)
    end
  end

  private

  def account
    FacebookAds::AdAccount.find_by(account_id: account_id)
  end

  def account_id
    '861827983860489'
  end
end
