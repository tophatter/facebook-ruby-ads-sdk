module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/reference/ad-account/adsets
  class AdSet < Base
    FIELDS = %w[
      id
      account_id
      campaign_id
      name
      status
      configured_status
      effective_status
      bid_strategy
      bid_amount
      billing_event
      optimization_goal
      pacing_type
      daily_budget
      budget_remaining
      lifetime_budget
      promoted_object
      targeting
      created_time
      updated_time
    ].freeze

    STATUSES = %w[
      ACTIVE
      PAUSED
      DELETED
      PENDING_REVIEW
      DISAPPROVED
      PREAPPROVED
      PENDING_BILLING_INFO
      CAMPAIGN_PAUSED
      ARCHIVED
      ADSET_PAUSED
    ].freeze

    BILLING_EVENTS = %w[APP_INSTALLS IMPRESSIONS].freeze

    OPTIMIZATION_GOALS = %w[
      NONE
      APP_INSTALLS
      BRAND_AWARENESS
      AD_RECALL_LIFT
      CLICKS
      ENGAGED_USERS
      EVENT_RESPONSES
      IMPRESSIONS
      LEAD_GENERATION
      LINK_CLICKS
      OFFER_CLAIMS
      OFFSITE_CONVERSIONS
      PAGE_ENGAGEMENT
      PAGE_LIKES
      POST_ENGAGEMENT
      REACH
      SOCIAL_IMPRESSIONS
      VIDEO_VIEWS
      APP_DOWNLOADS
      LANDING_PAGE_VIEWS
    ].freeze

    BID_STRATEGIES = %w[
      LOWEST_COST_WITHOUT_CAP
      LOWEST_COST_WITH_BID_CAP
      TARGET_COST
    ].freeze

    # AdAccount

    def ad_account
      @ad_account ||= AdAccount.find("act_#{account_id}")
    end

    # AdCampaign

    def ad_campaign
      @campaign ||= AdCampaign.find(campaign_id)
    end

    # Ad

    def ads(effective_status: ['ACTIVE'], limit: 100)
      Ad.paginate("/#{id}/ads", query: { effective_status: effective_status, limit: limit })
    end

    def create_ad(name:, creative_id:, status: 'PAUSED')
      query = { name: name, adset_id: id, creative: { creative_id: creative_id }.to_json, status: status }
      result = Ad.post("/act_#{account_id}/ads", query: query)
      Ad.find(result['id'])
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
