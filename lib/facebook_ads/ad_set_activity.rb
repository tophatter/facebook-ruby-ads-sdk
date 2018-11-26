# frozen_string_literal: true

module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/reference/ad-activity/
  class AdSetActivity < Base
    FIELDS = %w[
      actor_id
      actor_name
      event_time
      event_type
      extra_data
    ].freeze

    CATEGORIES = %w[
      ACCOUNT
      AD
      AD_SET
      AUDIENCE
      BID
      BUDGET
      CAMPAIGN
      DATE
      STATUS
      TARGETING
    ].freeze

    EVENT_TYPES = %w[
      ad_account_update
      spend_limit
      ad_account_reset_spend_limit
      ad_account_remove_spend_limit
      ad_account_set_business_information
      ad_account_update_status
      ad_account_add_user_to_role
      ad_account_remove_user_from_role
      add_images
      edit_images
      delete_images
      ad_account_billing_charge
      ad_account_billing_charge_failed
      ad_account_billing_chargeback
      ad_account_billing_chargeback_reversal
      ad_account_billing_decline
      ad_account_billing_refund
      billing_event
      add_funding_source
      remove_funding_source
      create_campaign_group
      update_campaign_name
      update_campaign_run_status
      update_campaign_group_spend_cap
      create_campaign_legacy
      update_campaign_budget
      update_campaign_duration
      campaign_ended
      create_ad_set
      update_ad_set_bidding
      update_ad_set_bid_strategy
      update_ad_set_budget
      update_ad_set_duration
      update_ad_set_run_status
      update_ad_set_name
      update_ad_set_optimization_goal
      update_ad_set_target_spec
      update_ad_set_bid_adjustments
      create_ad
      ad_review_approved
      ad_review_declined
      update_ad_creative
      edit_and_update_ad_creative
      update_ad_bid_info
      update_ad_bid_type
      update_ad_run_status
      update_ad_run_status_to_be_set_after_review
      update_ad_friendly_name
      update_ad_targets_spec
      update_adgroup_stop_delivery
      first_delivery_event
      create_audience
      update_audience
      delete_audience
      share_audience
      receive_audience
      unshare_audience
      remove_shared_audience
      unknown
      account_spending_limit_reached
      campaign_spending_limit_reached
      lifetime_budget_spent
      funding_event_initiated
      funding_event_successful
      update_ad_labels
      di_ad_set_learning_stage_exit
    ].freeze

    # belongs_to ad_set

    def ad_set
      @ad_set ||= AdSet.find(ad_set_id)
    end
  end
end
