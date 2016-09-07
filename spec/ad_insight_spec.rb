require 'spec_helper'

describe FacebookAds::AdInsight do

  describe '.find' do
    it 'Raises an exception' do
      expect { FacebookAds::AdInsight.find('test') }.to raise_error(Exception)
    end
  end

end
