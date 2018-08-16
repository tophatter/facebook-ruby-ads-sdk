# frozen_string_literal: true

module FacebookAds
  # An ad belongs to an ad set. It is created using an ad creative.
  # https://developers.facebook.com/docs/marketing-api/reference/adgroup
  class Ad < Base
    FIELDS   = %w[id account_id campaign_id adset_id adlabels bid_amount bid_info bid_type configured_status conversion_specs created_time creative effective_status last_updated_by_app_id name tracking_specs updated_time ad_review_feedback].freeze
    STATUSES = %w[ACTIVE PAUSED DELETED PENDING_REVIEW DISAPPROVED PREAPPROVED PENDING_BILLING_INFO CAMPAIGN_PAUSED ARCHIVED ADSET_PAUSED].freeze

    # belongs_to ad_account

    def ad_account
      @ad_set ||= AdAccount.find(account_id)
    end

    # belongs_to ad_campaign

    def ad_campaign
      @ad_set ||= AdCampaign.find(campaign_id)
    end

    # belongs_to ad_set

    def ad_set
      @ad_set ||= AdSet.find(adset_id)
    end

    # belongs_to ad_creative

    def ad_creative
      @ad_creative ||= AdCreative.find(creative['id'])
    end

    # has_many ad_insights

    def ad_insights(range: Date.today..Date.today, level: 'ad', time_increment: 1)
      query = {
        level: level,
        time_increment: time_increment,
        time_range: { 'since': range.first.to_s, 'until': range.last.to_s }
      }
      AdInsight.paginate("/#{id}/insights", query: query)
    end
  end
end
