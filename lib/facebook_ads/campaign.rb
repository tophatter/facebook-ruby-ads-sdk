# https://developers.facebook.com/docs/marketing-api/reference/ad-campaign-group
module FacebookAds
  class Campaign < Base

    FIELDS     = %w(id account_id buying_type can_use_spend_cap configured_status created_time effective_status name objective start_time stop_time updated_time spend_cap)
    STATUSES   = %w(ACTIVE PAUSED DELETED PENDING_REVIEW DISAPPROVED PREAPPROVED PENDING_BILLING_INFO CAMPAIGN_PAUSED ARCHIVED ADSET_PAUSED)
    OBJECTIVES = %w(CONVERSIONS MOBILE_APP_INSTALLS) # %w(BRAND_AWARENESS CANVAS_APP_ENGAGEMENT CANVAS_APP_INSTALLS CONVERSIONS EVENT_RESPONSES EXTERNAL LEAD_GENERATION LINK_CLICKS LOCAL_AWARENESS MOBILE_APP_ENGAGEMENT MOBILE_APP_INSTALLS OFFER_CLAIMS PAGE_LIKES POST_ENGAGEMENT PRODUCT_CATALOG_SALES REACH VIDEO_VIEWS)

    # belongs_to ad_account

    def ad_account
      @ad_account ||= FacebookAds::AdAccount.find("act_#{account_id}")
    end

    # has_many ad_sets

    def ad_sets(effective_status: ['ACTIVE'], limit: 100)
      FacebookAds::AdSet.paginate!("/#{id}/adsets", query: { effective_status: effective_status, limit: limit })
    end

    def create_ad_set(name:, promoted_object:, targeting:, daily_budget:, optimization_goal:, billing_event: 'IMPRESSIONS', status: 'ACTIVE', is_autobid: true)
      raise Exception, "Optimization goal must be one of: #{FacebookAds::AdSet::OPTIMIZATION_GOALS.to_sentence}" unless FacebookAds::AdSet::OPTIMIZATION_GOALS.include?(optimization_goal)
      raise Exception, "Billing event must be one of: #{FacebookAds::AdSet::BILLING_EVENTS.to_sentence}" unless FacebookAds::AdSet::BILLING_EVENTS.include?(billing_event)

      targeting.validate! # Will raise if invalid.

      ad_set = FacebookAds::AdSet.post!("/act_#{account_id}/adsets", query: { # Returns a FacebookAds::AdSet instance.
        campaign_id: id,
        name: name,
        targeting: targeting.to_hash.to_json,
        promoted_object: promoted_object.to_json,
        optimization_goal: optimization_goal,
        daily_budget: daily_budget,
        billing_event: billing_event,
        status: status,
        is_autobid: is_autobid
      })
      FacebookAds::AdSet.find(ad_set.id)
    end

    # has_many ad_insights

    def ad_insights(range: Date.today..Date.today)
      query    = FacebookAds::AdInsight.default_query.merge(level: 'ad', time_increment: 1, time_range: { 'since': range.first.to_s, 'until': range.last.to_s })
      response = get!("/#{id}/insights", query: query)
      data     = FacebookAds::AdInsight.paginate(response)
      data.present? ? data.map { |hash| FacebookAds::AdInsight.new(hash) } : []
    end

  end
end
