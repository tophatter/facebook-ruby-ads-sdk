## 0.6.3 (2018-05-17)
  - Replaced deprecated `is_autobid` with new `bid_strategy` field

## 0.6.2 (2018-05-08)
  - Set Product Catalog path to `/owned_product_catalogs` for API v2.11 compatibility

## 0.4 (2017-07-25)
 - Added ability to pass `bid_amount` parameter when creating ad sets
 - Ad Set `is_autobid` parameter now defaults to `nil` rather than `true`

## 0.3 (2017-07-24)
 - Added ability to pass `app_link` parameter with ad creatives

## 0.2 (2017-07-20)
 - Added ability to configure App Secret to be included with API requests

## 0.1.12 (2017-05-25)
 - Added complete set of ad campaign objectives. (#9, @cte)
 - Switched to rspec from minitest. (#8, @cte)
 - Formatting tweaks in exception error messages (#7, @dekaikiwi)
 - Added a reach_estimate method for ad accounts (ae35878, @cte)
