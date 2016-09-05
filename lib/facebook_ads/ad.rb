# https://developers.facebook.com/docs/marketing-api/reference/adgroup
module FacebookAds
  class Ad < Base

    FIELDS   = %w(id account_id campaign_id adset_id adlabels bid_amount bid_info bid_type configured_status conversion_specs created_time creative effective_status last_updated_by_app_id name tracking_specs updated_time ad_review_feedback)
    STATUSES = %w(ACTIVE PAUSED DELETED PENDING_REVIEW DISAPPROVED PREAPPROVED PENDING_BILLING_INFO CAMPAIGN_PAUSED ARCHIVED ADSET_PAUSED)

    # belongs_to ad_set

    def ad_set
      @ad_set ||= FacebookAds::AdSet.find(adset_id)
    end

    # belongs_to ad_creative

    def ad_creative
      @ad_creative ||= FacebookAds::AdCreative.find(creative['id'])
    end

  end
end
