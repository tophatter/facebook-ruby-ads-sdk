module FacebookAds
  # An ad set belongs to a campaign and has many ads.
  # https://developers.facebook.com/docs/marketing-api/reference/ad-campaign
  class AdSet < Base
    FIELDS             = %w(id account_id campaign_id adlabels adset_schedule bid_amount bid_info billing_event configured_status created_time creative_sequence effective_status end_time frequency_cap frequency_cap_reset_period frequency_control_specs is_autobid lifetime_frequency_cap lifetime_imps name optimization_goal promoted_object rf_prediction_id rtb_flag start_time targeting updated_time use_new_app_click pacing_type budget_remaining daily_budget lifetime_budget).freeze
    STATUSES           = %w(ACTIVE PAUSED DELETED PENDING_REVIEW DISAPPROVED PREAPPROVED PENDING_BILLING_INFO CAMPAIGN_PAUSED ARCHIVED ADSET_PAUSED).freeze
    BILLING_EVENTS     = %w(APP_INSTALLS IMPRESSIONS).freeze
    OPTIMIZATION_GOALS = %w(APP_INSTALLS OFFSITE_CONVERSIONS).freeze

    # belongs_to ad_account

    def ad_account
      @ad_account ||= AdAccount.find(account_id)
    end

    # belongs_to ad_campaign

    def ad_campaign
      @campaign ||= AdCampaign.find(campaign_id)
    end

    # has_many ads

    def ads(effective_status: ['ACTIVE'], limit: 100)
      Ad.paginate("/#{id}/ads", query: { effective_status: effective_status, limit: limit })
    end

    def create_ad(name:, creative_id:)
      ad = Ad.post("/act_#{account_id}/ads", query: { name: name, adset_id: id, creative: { creative_id: creative_id }.to_json }, objectify: true) # Returns an Ad instance.
      Ad.find(ad.id)
    end
  end
end
