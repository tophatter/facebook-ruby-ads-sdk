module FacebookAds
  class AdException < StandardError
    attr_accessor :code, :title, :message
  end
end
