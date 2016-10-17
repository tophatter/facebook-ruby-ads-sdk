require 'spec_helper'

describe FacebookAds::AdSet do
  describe '.find' do
    it 'Finds an AdSet instance' do
      id = '6057810946970'
      ad_set = FacebookAds::AdSet.find(id)
      expect(ad_set.id).to eql(id)
    end
  end
end
