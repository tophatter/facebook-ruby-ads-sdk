# frozen_string_literal: true

require 'spec_helper'

describe FacebookAds::AdSet do
  # def test_create
  #   vcr do
  #     ad_campaign = FacebookAds::AdCampaign.find('6069436026057')
  #     ad_set = ad_campaign.create_ad_set(
  #       name: 'Test',
  #       promoted_object: {
  #         pixel_id: '1472889202927380',
  #         custom_event_type: 'PURCHASE'
  #       },
  #       targeting: {
  #         age_max: 65,
  #         age_min: 18,
  #         app_install_state: 'not_installed',
  #         excluded_custom_audiences: [{ "name"=>"All-Users-2016-07-28", "id"=>"6068994792257" }],
  #         genders: [2],
  #         geo_locations: { countries: %w(US), location_types: %w(home recent) },
  #         locales: [24, 6],
  #         publisher_platforms: %w(facebook instagram audience_network),
  #         device_platforms: %w(desktop),
  #         facebook_positions: %w(feed right_hand_column)
  #       },
  #       daily_budget: 1000,
  #       optimization_goal: 'OFFSITE_CONVERSIONS'
  #     )
  #     assert_equal '6081945233457', ad_set.id
  #     assert_equal '1000', ad_set.daily_budget
  #     assert_equal 'OFFSITE_CONVERSIONS', ad_set.optimization_goal
  #   end
  # end
  #
  # def test_update
  #   vcr do
  #     ad_set = FacebookAds::AdSet.find('6078462927057')
  #     assert ad_set.update(daily_budget: 149900)
  #   end
  # end
  #
  # def test_destroy
  #   vcr do
  #     ad_set = FacebookAds::AdSet.find('6081945233457')
  #     assert ad_set.destroy
  #   end
  # end
end
