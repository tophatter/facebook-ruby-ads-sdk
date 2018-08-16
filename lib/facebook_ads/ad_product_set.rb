# frozen_string_literal: true

module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/reference/product-set
  class AdProductSet < Base
    FIELDS = %w[id auto_creation_url filter name product_catalog product_count].freeze
  end
end
