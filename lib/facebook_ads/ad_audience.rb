# frozen_string_literal: true

module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/reference/custom-audience
  class AdAudience < Base
    FIELDS = %w[id account_id subtype name description approximate_count data_source delivery_status external_event_source lookalike_audience_ids lookalike_spec operation_status opt_out_link permission_for_actions pixel_id retention_days rule time_content_updated time_created time_updated].freeze

    # belongs_to ad_account

    def ad_account
      @ad_account ||= AdAccount.find("act_#{account_id}")
    end

    # actions

    def share(account_id)
      AdAccount.post(
        "/#{id}/share_with_objects",
        query: {
          share_with_object_id: account_id,
          share_with_object_type: 'Account'
        }
      )
    end
  end
end
