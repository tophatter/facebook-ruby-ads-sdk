## 0.7.0 (2020-09-29)
  - Add stubborn network call helpers.
  - Update default version to v7.0.
  - Switch from TravisCI to CircleCI.
  - Remove coveralls.
  - Require ruby 2.5+.
  - Update Rubocop & fix warnings.

## 0.6.11 (2020-02-28)
  - Fixed memoization in `FacebookAds::Ad`.

## 0.6.10 (2019-05-06)
  - Set default version to 3.2.
  - Removed `relevance_score` from the list of default fields in `AdInsight`.

## 0.6.9 (2019-03-25)
  - Added the following fields to `AdCreative`: `product_set_id` and `url_tags`. (#37, @cte)

## 0.6.7 (2019-03-07)
  - Added the following fields to `AdSet`: `attribution_spec`, `start_time` and `end_time`. (#36, @cte)

## 0.6.6 (2018-11-29)
  - Added ability to pass date range when fetching `ad_set_activities`. (#34, @amosharrafa)

## 0.6.5 (2018-11-26)
  - Expose `ad_set_activities` for `ad_sets`. (#31, @amosharrafa)

## 0.6.4 (2018-10-03)
  - Expose `budget_remaining`, `daily_budget`, `lifetime_budget` for the `AdCampaign` object. You now have the option to set the budget ad the campaign level instead of the ad set level.

## 0.6.3 (2018-05-17)
  - Replaced deprecated `is_autobid` with new `bid_strategy` field.

## 0.6.2 (2018-05-08)
  - Set Product Catalog path to `/owned_product_catalogs` for API v2.11 compatibility.

## 0.4 (2017-07-25)
 - Added ability to pass `bid_amount` parameter when creating ad sets.
 - Ad Set `is_autobid` parameter now defaults to `nil` rather than `true`.

## 0.3 (2017-07-24)
 - Added ability to pass `app_link` parameter with ad creatives.

## 0.2 (2017-07-20)
 - Added ability to configure App Secret to be included with API requests.

## 0.1.12 (2017-05-25)
 - Added complete set of ad campaign objectives. (#9, @cte)
 - Switched to rspec from minitest. (#8, @cte)
 - Formatting tweaks in exception error messages (#7, @dekaikiwi)
 - Added a reach_estimate method for ad accounts (ae35878, @cte)
