# frozen_string_literal: true

module FacebookAds
  class Account < Base
    FIELDS = %w[].freeze

    class << self
      def all(query = {})
        get('/me/accounts', query: query, objectify: true)
      end
    end
  end
end
