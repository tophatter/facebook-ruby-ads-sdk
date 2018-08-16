# frozen_string_literal: true

module FacebookAds
  # An ad user belongs to an ad account.
  # https://developers.facebook.com/docs/marketing-api/reference/ad-campaign-group
  class AdUser < Base
    FIELDS = %w[].freeze

    # belongs_to ad_account

    def ad_account
      @ad_account ||= AdAccount.find("act_#{account_id}")
    end
  end
end
