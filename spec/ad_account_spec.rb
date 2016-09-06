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
      account = FacebookAds::AdAccount.find('act_861827983860489')
      expect(account.id).to eql('act_861827983860489')
    end
  end

  describe '.find_by' do
    it 'Finds an AdAccount by name' do
      account = FacebookAds::AdAccount.find_by(name: 'Android')
      expect(account.name).to eql('Android')
    end
  end

end
