# frozen_string_literal: true

module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/reference/product-feed
  class AdProductFeed < Base
    FIELDS = %w[id country created_time default_currency deletion_enabled delimiter encoding file_name latest_upload name product_count quoted_fields_mode schedule].freeze
  end
end
