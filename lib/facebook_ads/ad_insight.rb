# frozen_string_literal: true

module FacebookAds
  # Ad insights exist for ad accounts, ad campaigns, ad sets, and ads.
  # A lot more can be done here.
  # https://developers.facebook.com/docs/marketing-api/insights/overview
  # https://developers.facebook.com/docs/marketing-api/insights/parameters
  class AdInsight < Base
    FIELDS = %w[account_id campaign_id adset_id ad_id objective impressions unique_actions cost_per_unique_action_type clicks cpc cpm cpp ctr spend reach].freeze

    class << self
      def find(_id)
        raise NotImplementedError
      end
    end

    def update(_data)
      raise NotImplementedError
    end

    def destroy
      raise NotImplementedError
    end
  end
end
