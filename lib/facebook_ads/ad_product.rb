# frozen_string_literal: true

module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/reference/product-item
  class AdProduct < Base
    FIELDS = %w[id retailer_id name description brand category currency price image_url url].freeze
  end
end
