module FacebookAds
  # Ad insights exist for ad accounts, ad campaigns, ad sets, and ads.
  # A lot more can be done here.
  # https://developers.facebook.com/docs/marketing-api/insights/overview
  class AdInsight < Base

    FIELDS = %w(ad_id objective impressions unique_actions cost_per_unique_action_type clicks cpc cpm ctr spend)

  end
end
