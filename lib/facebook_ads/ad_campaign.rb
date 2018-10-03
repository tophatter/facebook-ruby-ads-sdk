# frozen_string_literal: true

module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/reference/ad-campaign-group
  class AdCampaign < Base
    FIELDS = %w[
      id
      account_id
      buying_type
      can_use_spend_cap
      configured_status
      created_time
      effective_status
      name
      objective
      start_time
      stop_time
      updated_time spend_cap
      budget_remaining daily_budget lifetime_budget
    ].freeze

    STATUSES = %w[
      ACTIVE PAUSED
      DELETED
      PENDING_REVIEW
      DISAPPROVED
      PREAPPROVED
      PENDING_BILLING_INFO
      CAMPAIGN_PAUSED
      ARCHIVED
      ADSET_PAUSED
    ].freeze

    OBJECTIVES = %w[
      APP_INSTALLS
      BRAND_AWARENESS
      CONVERSIONS
      EVENT_RESPONSES
      LEAD_GENERATION
      LINK_CLICKS
      LOCAL_AWARENESS
      OFFER_CLAIMS
      PAGE_LIKES
      POST_ENGAGEMENT
      PRODUCT_CATALOG_SALES
      REACH
      VIDEO_VIEWS
    ].freeze

    # AdAccount

    def ad_account
      @ad_account ||= AdAccount.find("act_#{account_id}")
    end

    # AdSet

    def ad_sets(effective_status: ['ACTIVE'], limit: 100)
      AdSet.paginate("/#{id}/adsets", query: { effective_status: effective_status, limit: limit })
    end

    def create_ad_set(name:, promoted_object: {}, targeting:, daily_budget: nil, lifetime_budget: nil, end_time: nil, optimization_goal:, billing_event: 'IMPRESSIONS', status: 'ACTIVE', bid_strategy: nil, bid_amount: nil)
      raise Exception, "Optimization goal must be one of: #{AdSet::OPTIMIZATION_GOALS.join(', ')}" unless AdSet::OPTIMIZATION_GOALS.include?(optimization_goal)
      raise Exception, "Billing event must be one of: #{AdSet::BILLING_EVENTS.join(', ')}" unless AdSet::BILLING_EVENTS.include?(billing_event)
      raise Exception, "Bid strategy must be one of: #{AdSet::BID_STRATEGIES.join(', ')}" unless AdSet::BID_STRATEGIES.include?(bid_strategy)

      if targeting.is_a?(Hash)
        # NOP
      else
        targeting.validate! # Will raise if invalid.
        targeting = targeting.to_hash
      end

      query = {
        campaign_id: id,
        name: name,
        targeting: targeting.to_json,
        promoted_object: promoted_object.to_json,
        optimization_goal: optimization_goal,
        billing_event: billing_event,
        status: status,
        bid_strategy: bid_strategy,
        bid_amount: bid_amount
      }

      if daily_budget && lifetime_budget
        raise Exception 'Only one budget may be set between daily_budget and life_budget'
      elsif daily_budget
        query[:daily_budget] = daily_budget
      elsif lifetime_budget
        query[:lifetime_budget] = lifetime_budget
        query[:end_time] = end_time
      end

      result = AdSet.post("/act_#{account_id}/adsets", query: query)
      AdSet.find(result['id'])
    end

    # AdInsight

    def ad_insights(range: Date.today..Date.today, level: 'ad', time_increment: 1)
      query = {
        level: level,
        time_increment: time_increment,
        time_range: { since: range.first.to_s, until: range.last.to_s }
      }

      AdInsight.paginate("/#{id}/insights", query: query)
    end
  end
end
