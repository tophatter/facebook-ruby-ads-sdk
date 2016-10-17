module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/dynamic-product-ads/product-catalog#create-product-catalog
  class AdProductCatalog < Base
    FIELDS   = %w(id account_id campaign_id adset_id adlabels bid_amount bid_info bid_type configured_status conversion_specs created_time creative effective_status last_updated_by_app_id name tracking_specs updated_time ad_review_feedback).freeze
    STATUSES = %w(ACTIVE PAUSED DELETED PENDING_REVIEW DISAPPROVED PREAPPROVED PENDING_BILLING_INFO CAMPAIGN_PAUSED ARCHIVED ADSET_PAUSED).freeze

    # belongs_to ad_account

    def ad_account
      @ad_set ||= FacebookAds::AdAccount.find(account_id)
    end
  end
end
