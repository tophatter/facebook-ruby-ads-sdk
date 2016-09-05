# https://developers.facebook.com/docs/marketing-api/reference/ad-campaign
module FacebookAds
  class AdSet < Base

    FIELDS             = %w(id account_id campaign_id adlabels adset_schedule bid_amount bid_info billing_event configured_status created_time creative_sequence effective_status end_time frequency_cap frequency_cap_reset_period frequency_control_specs is_autobid lifetime_frequency_cap lifetime_imps name optimization_goal promoted_object rf_prediction_id rtb_flag start_time targeting updated_time use_new_app_click pacing_type budget_remaining daily_budget lifetime_budget)
    STATUSES           = %w(ACTIVE PAUSED DELETED PENDING_REVIEW DISAPPROVED PREAPPROVED PENDING_BILLING_INFO CAMPAIGN_PAUSED ARCHIVED ADSET_PAUSED)
    BILLING_EVENTS     = %w(APP_INSTALLS IMPRESSIONS) # %w(CLICKS LINK_CLICKS OFFER_CLAIMS PAGE_LIKES POST_ENGAGEMENT VIDEO_VIEWS)
    OPTIMIZATION_GOALS = %w(APP_INSTALLS OFFSITE_CONVERSIONS) # %w(NONE BRAND_AWARENESS CLICKS ENGAGED_USERS EXTERNAL EVENT_RESPONSES IMPRESSIONS LEAD_GENERATION LINK_CLICKS OFFER_CLAIMS PAGE_ENGAGEMENT PAGE_LIKES POST_ENGAGEMENT REACH SOCIAL_IMPRESSIONS VIDEO_VIEWS)

    # belongs_to campaign

    def campaign
      @campaign ||= FacebookAds::Campaign.find(campaign_id)
    end

    # has_many ads

    def ads(effective_status: ['ACTIVE'], limit: 100)
      FacebookAds::Ad.paginate!("/#{id}/ads", query: { effective_status: effective_status, limit: limit })
    end

    def create_ad(name:, creative_id:)
      ad = FacebookAds::Ad.post!("/act_#{account_id}/ads", query: { name: name, adset_id: id, creative: { creative_id: creative_id }.to_json }) # Returns a FacebookAds::Ad instance.
      FacebookAds::Ad.find(ad.id)
    end

  end
end
