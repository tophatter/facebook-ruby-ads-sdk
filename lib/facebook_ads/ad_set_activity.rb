# frozen_string_literal: true

module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/reference/ad-activity/
  # curl -G
  # \ -d 'fields=actor_id,actor_name,event_time,event_type,extra_data,translated_event_type'
  # \ -d 'access_token=<access_token>' \ https://graph.facebook.com/v3.1/<ad_set_id>/activities?
  class AdSetActivity < Base
    FIELDS = %w[
      actor_id
      actor_name
      event_time
      event_type
      extra_data
      translated_event_type
    ].freeze
  end
end
