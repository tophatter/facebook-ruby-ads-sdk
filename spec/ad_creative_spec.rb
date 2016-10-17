require 'spec_helper'

describe FacebookAds::AdCreative do
  describe '.find' do
    it 'Finds an AdCreative instance' do
      id = '6057824295570'
      creative = FacebookAds::AdCreative.find(id)
      expect(creative.id).to eql(id)
      expect(creative.object_story_spec.class).to eql(Hash)
    end
  end
end
