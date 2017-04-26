require 'spec_helper'

# FACEBOOK_ACCESS_TOKEN=... rspec spec/facebook_ads/ad_account_spec.rb
describe FacebookAds::AdAccount do
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
end
