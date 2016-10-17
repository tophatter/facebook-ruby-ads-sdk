require 'spec_helper'

describe FacebookAds::Ad do
  describe '.find' do
    it 'Finds an Ad instance' do
      id = '6057810634370'
      ad = FacebookAds::Ad.find(id)
      expect(ad.id).to eql(id)
    end
  end
end
