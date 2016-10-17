require 'spec_helper'

describe FacebookAds::AdImage do
  describe '.find' do
    it 'Raises an exception' do
      expect { FacebookAds::AdImage.find('test') }.to raise_error(Exception)
    end
  end
end
