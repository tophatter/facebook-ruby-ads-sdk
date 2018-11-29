[![Gem Version](https://badge.fury.io/rb/facebook_ads.svg)](https://badge.fury.io/rb/facebook_ads)
[![Build Status](https://travis-ci.org/tophatter/facebook-ruby-ads-sdk.svg?branch=master)](https://travis-ci.org/tophatter/facebook-ruby-ads-sdk)
[![Coverage Status](https://coveralls.io/repos/github/tophatter/facebook-ruby-ads-sdk/badge.svg?branch=master)](https://coveralls.io/github/tophatter/facebook-ruby-ads-sdk?branch=master)

# [Facebook Marketing API](https://developers.facebook.com/docs/marketing-apis) SDK for Ruby

![Facebook Ads](http://i.imgur.com/GrxAj07.png)

This gem allows you to manage your Facebook Ads using a ruby interface. It allows you to list, create, update and destroy Facebook Ad objects (campaigns, ad sets, ads, etc) and get real-time insights about the performance of Facebook Ads.

## Install

```bash
gem install facebook_ads
```

Or, add the following to your Gemfile:

```ruby
gem 'facebook_ads', '~> 0.1'
```

## Permissions

You'll need an [Access Token](https://developers.facebook.com/docs/marketing-api/authentication) with `ads_management` permissions in order to use Facebook's Marketing API.

```ruby
FacebookAds.access_token = '[YOUR_ACCESS_TOKEN]'
```

You can also optionally include an [App Secret](https://developers.facebook.com/docs/accountkit/graphapi#app-tokens) if you need one for your application.

```ruby
FacebookAds.app_secret = '[YOUR_APP_SECRET]'
```

## API Version

This gem currently uses v2.9 of the Marketing API (2.10 is released as of 7/18/2017). You can change the version as desired with the following:

```ruby
FacebookAds.base_uri = 'https://graph.facebook.com/v2.10'
```

## Console

This gem provides a console using [Pry](https://github.com/pry/pry) and [AwesomePrint](https://github.com/awesome-print/awesome_print) for you to test & debug.
It reads the Access Token from a file called test_access_token.

```bash
echo [YOUR_ACCESS_TOKEN] > test_access_token
bin/facebook_ads_console
```

## Usage Examples

A strong understanding of the Facebook Ads [object structure](https://developers.facebook.com/docs/marketing-api/buying-api) will greatly help you use this gem.

The basic object structure:

![Facebook Ads Object Structure](http://i.imgur.com/Ak4FQ4H.jpg)

In total, there are 7 Facebook Ads objects that can be interacted with via this gem: AdAccount, AdCampaign, AdImage, AdCreative, AdSet, Ad and AdInsight.

The typical flow is as follows:

1. Create an **AdCampaign** for an **AdAccount**.
2. Create **AdImages** for an **AdAccount**.
3. Create an **AdCreative** for an **AdAccount** using the **AdImages** from #2.
4. Create ad **AdSet** for the **AdCampaign** from #1.
5. Create an **Ad** for the **AdSet** from #4 using the **AdCreative** from #3.
6. Monitor the performance of the **Ad** from #5 using **AdInsights**.
7. Update the daily budget of the **AdSet** from #4 as needed.

You'll find usage examples for each of these 7 objects below.

___

### [Ad Accounts](https://developers.facebook.com/docs/marketing-api/reference/ad-account) (Fetch, Find, Update)

Fetch all accounts that can be accessed using your access token:
```ruby
accounts = FacebookAds::AdAccount.all
```

Find an account by ID:
```ruby
account = FacebookAds::AdAccount.find('act_1132789356764349')
```

Find an account by name:
```ruby
account = FacebookAds::AdAccount.find_by(name: 'ReFuel4')
```

Update an account (using both .save() and .update()):
```ruby
account.name = 'ReFuel4 [Updated]'
account = account.save # Returns the updated object.
account.update(name: 'ReFuel4') # Returns a boolean.
```

The list of fields that can be updated is [here](https://developers.facebook.com/docs/marketing-api/reference/ad-account#Updating).

___

### [Ad Campaigns](https://developers.facebook.com/docs/marketing-api/reference/ad-campaign-group) (Fetch, Find, Create, Update, Destroy)

Fetch all active campaigns:
```ruby
campaigns = account.ad_campaigns
```

Fetch all paused campaigns (can pass multiple statuses in the array):
```ruby
campaigns = account.ad_campaigns(effective_status: ['PAUSED'])
```
See FacebookAds::AdCampaign::STATUSES for a list of all statuses.

Fetch all campaigns:
```ruby
campaigns = account.ad_campaigns(effective_status: nil)
```

Create a new campaign for website conversions that is initially paused:
```ruby
campaign = account.create_ad_campaign(
  name: 'Test Campaign',
  objective: 'CONVERSIONS',
  status: 'PAUSED'
)
```
See FacebookAds::AdCampaign::OBJECTIVES for a list of all objectives.

Find a campaign by ID:
```ruby
campaign = FacebookAds::AdCampaign.find(campaign.id)
```

Update a campaign (using both .save() and .update()):
```ruby
campaign.status = 'ACTIVE'
campaign = campaign.save # Returns the updated object.
campaign.update(status: 'PAUSED') # Returns a boolean.
```
The list of fields that can be updated is [here](https://developers.facebook.com/docs/marketing-api/reference/ad-campaign-group#Updating).

Destroy a campaign:
```ruby
campaign.destroy
```

___

### [Ad Images](https://developers.facebook.com/docs/marketing-api/reference/ad-image) (Fetch, Find, Create, Destroy)

Notes:
* Images cannot be updated.
* You can upload the same image multiple times and Facebook will de-duplicate them server side.
* An image will always generate the same hash on Facebook's end - even across ad accounts.
* Image uploading via a URL currently assumes a \*nix system (Mac OS, linux). It likely will fail on Windows. A cross-platform tempfile-based solution is in the works.
* You can't destroy an image if its being used by a creative. You have to destroy the creative first.

Fetch all images owned by an account:
```ruby
ad_images = account.ad_images
```

Create images using an array of URLs:
```ruby
ad_images = account.create_ad_images([
  'https://d38eepresuu519.cloudfront.net/485674b133dc2f1d66d20c9d52c62bec/original.jpg',
  'https://d38eepresuu519.cloudfront.net/3977d2a47b584820969e2acf4d923e33/original.jpg'
])
```

Find images using their hash values:
```ruby
ad_images = account.ad_images(hashes: ad_images.map(&:hash))
```

Destroy images:
```ruby
ad_images.map(&:destroy)
```

___

### [Ad Creatives](https://developers.facebook.com/docs/marketing-api/reference/ad-creative) (Fetch, Find, Create, Update, Destroy)

Notes:
* I'd like to add a configuration object that allows you to specify the Facebook Page, Instagram account, website, iOS app and/or Android app that you will be advertising. This is needed when creating both Ad Creative objects and Ad Set objects.

Fetch all creatives owned by an account:
```ruby
ad_creatives = account.ad_creatives
```

Create a carousel creative driving installs for an Android app:
```ruby
carousel_ad_creative = account.create_ad_creative({
  name: 'Test Carousel Creative',
  page_id: '300664329976860', # Add your Facebook Page ID here.
  link: 'http://play.google.com/store/apps/details?id=com.tophatter', # Add your Play Store ID here.
  message: 'A message.',
  assets: [
    { hash: ad_images.first.hash, title: 'Image #1 Title' },
    { hash: ad_images.second.hash, title: 'Image #2 Title' }
  ],
  call_to_action_type: 'SHOP_NOW',
  multi_share_optimized: true,
  multi_share_end_card: false
}, creative_type: 'carousel')
```
See FacebookAds::AdCreative::CALL_TO_ACTION_TYPES for a list of all call to action types.

Create a single image creative advertising an Android app:
```ruby
image_ad_creative = account.create_ad_creative({
  name: 'Test Single Image Creative',
  page_id: '300664329976860', # Add your Facebook Page ID here.
  message: 'A message.',
  link: 'http://play.google.com/store/apps/details?id=com.tophatter', # Add your Play Store ID here.
  link_title: 'A link title.',
  image_hash: ad_images.first.hash,
  call_to_action_type: 'SHOP_NOW'
}, creative_type: 'image')
```

Create a single creative for a web link:
```ruby
image_ad_creative = account.create_ad_creative({
  title: 'Test Link Title',
  body: 'Link Description Text',
  object_url: 'www.example.com/my-ad-link',
  link_url: 'www.example.com/my-ad-link',
  image_hash: ad_images.first.hash,
}, creative_type: 'link')
```

The options will be different depending on the thing being advertised (Android app, iOS app or website).

Find a creative by ID:
```ruby
ad_creative = FacebookAds::AdCreative.find(ad_creative.id)
```

Update a creative (using both .save() and .update()):
```ruby
ad_creative.name = 'Test Carousel Creative [Updated]'
ad_creative = ad_creative.save # Returns the updated object.
ad_creative.update(name: 'Test Carousel Creative') # Returns a boolean.
```
The list of fields that can be updated is [here](https://developers.facebook.com/docs/marketing-api/reference/ad-creative#Updating).

Destroy a creative:
```ruby
ad_creative.destroy
```

___

### [Ad Sets](https://developers.facebook.com/docs/marketing-api/reference/ad-campaign) (Fetch, Find, Create, Update, Destroy)

Notes:
* It's important to make sure your targeting spec makes sense in the context of the promoted object. For example if the promoted object is an iOS app and the targeting spec specifies Android devices your ads are not likely to perform well since no one will be able to download your iOS app.

You interact with ad sets via a campaign:
```ruby
campaign = account.ad_campaigns(effective_status: nil).first
```

Fetch all active ad sets for a campaign:
```ruby
ad_sets = campaign.ad_sets
```

Fetch all paused ad sets for a campaign (can pass multiple statuses in the array):
```ruby
ad_sets = campaign.ad_sets(effective_status: ['PAUSED'])
```
See FacebookAds::AdSet::STATUSES for a list of all statuses.

Fetch all ad sets for a campaign:
```ruby
ad_sets = campaign.ad_sets(effective_status: nil)
```

Specify the audience targeted by this ad set:
```ruby
targeting                   = FacebookAds::AdTargeting.new
targeting.genders           = [FacebookAds::AdTargeting::WOMEN]
targeting.age_min           = 29
targeting.age_max           = 65
targeting.countries         = ['US']
targeting.user_os           = [FacebookAds::AdTargeting::ANDROID_OS]
targeting.user_device       = FacebookAds::AdTargeting::ANDROID_DEVICES
targeting.app_install_state = FacebookAds::AdTargeting::NOT_INSTALLED
```
A lot can be done with targeting. You can learn more about targeting specs [here](https://developers.facebook.com/docs/marketing-api/targeting-specs).

Create an ad set to drive installs to an Android app using the targeting above:
```ruby
ad_set = campaign.create_ad_set(
  name: 'Test Ad Set',
  targeting: targeting,
  promoted_object: { # This can be an Android app, iOS app or pixel ID, plus an optional custom event.
    application_id: '295802707128640',
    object_store_url: 'http://play.google.com/store/apps/details?id=com.tophatter',
    custom_event_type: 'PURCHASE'
  },
  optimization_goal: 'OFFSITE_CONVERSIONS',
  daily_budget: 500, # This is in cents, so the daily budget here is $5.
  billing_event: 'IMPRESSIONS',
  status: 'PAUSED',
  bid_strategy: 'LOWEST_COST_WITHOUT_CAP'
)
```
See FacebookAds::AdSet::OPTIMIZATION_GOALS for a list of all optimization goals.
See FacebookAds::AdSet::BILLING_EVENTS for a list of all billing events.
See FacebookAds::AdSet::BID_STRATEGIES for a list of all bid strategies.

Find an ad set by ID:
```ruby
ad_set = FacebookAds::AdSet.find(ad_set.id)
```

Update an ad set (using both .save() and .update()):
```ruby
ad_set.status = 'ACTIVE'
ad_set.daily_budget = 400
ad_set = ad_set.save # Returns the updated object.
ad_set.update(status: 'PAUSED', daily_budget: 500) # Returns a boolean.
```
The list of fields that can be updated is [here](https://developers.facebook.com/docs/marketing-api/reference/ad-campaign#Updating).

Destroy an ad set:
```ruby
ad_set.destroy
```

___

### [Ad Set Activities](https://developers.facebook.com/docs/marketing-api/reference/ad-activity) (Fetch)

You interact with activities via an ad set:
```ruby
ad_set = account.ad_sets(effective_status: nil).first
```

Fetch all activities in last 24 hours for an ad set:
```ruby
activities = ad_set.activities
```

Fetch all activities in last 48 hours for an ad set:
```ruby
activities = ad_set.activities(from: 2.days.ago, to: Date.today)
```

___

### [Ads](https://developers.facebook.com/docs/marketing-api/reference/adgroup) (Fetch, Find, Create, Update, Destroy)

You interact with ads via an ad set:
```ruby
ad_set = account.ad_sets(effective_status: nil).first
```

Fetch all active ads for an ad set:
```ruby
ads = ad_set.ads
```

Fetch all paused ads for an ad set (can pass multiple statuses in the array):
```ruby
ads = ad_set.ads(effective_status: ['PAUSED'])
```
See FacebookAds::Ad::STATUSES for a list of all statuses.

Fetch all ads for an ad set:
```ruby
ads = ad_set.ads(effective_status: nil)
```

Fetch a creative that we'll use to create an ad:
```ruby
ad_creative = account.ad_creatives.first
```

Create an ad:
```ruby
ad = ad_set.create_ad(name: 'Test Ad', creative_id: ad_creative.id)
```

Find an ad by ID:
```ruby
ad = FacebookAds::Ad.find(ad.id)
```

Update an ad (using both .save() and .update()):
```ruby
ad.name = 'Test Ad [Updated]'
ad.status = 'ACTIVE'
ad = ad.save # Returns the updated object.
ad.update(name: 'Test Ad', status: 'PAUSED') # Returns a boolean.
```
The list of fields that can be updated is [here](https://developers.facebook.com/docs/marketing-api/reference/adgroup#Updating).

Destroy an ad:
```ruby
ad.destroy
```

___

### [Ad Insights](https://developers.facebook.com/docs/marketing-api/insights/overview) (Fetch)

Fetch today's insights for an account:
```ruby
account.ad_insights
```

Fetch yesterday's insights for an account:
```ruby
account.ad_insights(range: Date.yesterday..Date.yesterday)
```

Fetch today's insights for a campaign:
```ruby
account.ad_campaigns.last.ad_insights
```

Fetch yesterday's insights for a campaign:
```ruby
account.ad_campaigns.last.ad_insights(range: Date.yesterday..Date.yesterday)
```

___

### [Product Catalogs](https://developers.facebook.com/docs/marketing-api/reference/product-catalog)

List all product catalogs:
```ruby
FacebookAds::AdProductCatalog.all
```

Create a new product catalog:
```ruby
catalog = FacebookAds::AdProductCatalog.create(name: 'test')
```

Delete a product catalog:
```ruby
catalog.destroy
```

## @TODO:

* [Batch operations](https://developers.facebook.com/docs/marketing-api/batch-requests).
