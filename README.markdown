## [Facebook Marketing API](https://developers.facebook.com/docs/marketing-apis) - Ruby SDK

![Facebook Ads](http://i.imgur.com/GrxAj07.png)

This gem allows you to manage your Facebook Ads using a ruby interface. It allows you to create, updated and destroy Facebook Ad objects (campaigns, ad sets, ads, etc) and get real-time insights about the performance of Facebook Ads. A strong understanding of the Facebook Ads [object structure](https://developers.facebook.com/docs/marketing-api/buying-api) will greatly help you use this gem.

The basic object structure:

![Facebook Ads Object Structure](http://i.imgur.com/Ak4FQ4H.jpg)

In total, there are 7 Facebook Ads objects that can be interacted with via this gem: AdAccount, Campaign, AdImage, AdCreative, AdSet, Ad and AdInsight. You'll find code examples below for each of these objects.

The typical flow is as follows:

1. Create a **Campaign** for an **AdAccount**.
2. Create **AdImages** for an **AdAccount**.
3. Create an **AdCreative** for an **AdAccount** using the **AdImages** from #2.
4. Create ad **AdSet** for the **Campaign** from #1.
5. Create an **Ad** for the **AdSet** from #4 using the **AdCreative** from #3.
6. Monitor the performance of the **Ad** from #5 using **AdInsights**.
7. Update the daily budget of the **AdSet** from #4 as needed.

### Getting Started

You'll need an [Access Token](https://developers.facebook.com/docs/marketing-api/authentication) with `ads_management` permissions.

```ruby
FacebookAds.access_token = '[YOUR_ACCESS_TOKEN]'
```

This gem provides a console using [Pry](https://github.com/pry/pry) and [AwesomePrint](https://github.com/awesome-print/awesome_print) for you to test & debug.
It reads the Access Token from a file called test_access_token.

```bash
echo [YOUR_ACCESS_TOKEN] > test_access_token
bin/console
```

### [Ad Accounts](https://developers.facebook.com/docs/marketing-api/reference/ad-account) (Fetch, Find)

```ruby
# Fetch all accounts that can be accessed using your access token:
accounts = FacebookAds::AdAccount.all

# Find an account by ID:
account = FacebookAds::AdAccount.find('act_1132789356764349')

# Find an account by name:
account = FacebookAds::AdAccount.find_by(name: 'ReFuel4')
```

### [Campaigns](https://developers.facebook.com/docs/marketing-api/reference/ad-campaign-group) (Fetch, Find, Create, Destroy)

```ruby
# Fetch all active campaigns:
campaigns = account.campaigns

# Fetch all paused campaigns (can pass multiple statuses in the array):
campaigns = account.campaigns(effective_status: ['PAUSED']) # See FacebookAds::Campaign::STATUSES for a list of all statuses.

# Fetch all campaigns:
campaigns = account.campaigns(effective_status: nil)

# Create a new campaign for website conversions that is initially paused:
campaign = account.create_campaign(
  name: 'Test Campaign',
  objective: 'CONVERSIONS', # See FacebookAds::Campaign::OBJECTIVES for a list of all objectives.
  status: 'PAUSED'
)

# Find a campaign by ID:
campaign = FacebookAds::Campaign.find(campaign.id)

# Destroy a campaign:
campaign.destroy
```

### [Ad Images](https://developers.facebook.com/docs/marketing-api/reference/ad-image) (Fetch, Find, Create, Destroy)

```ruby
# Fetch all images owned by an account:
ad_images = account.ad_images

# Create images using an array of URLs:
ad_images = account.create_ad_images([
  'https://d38eepresuu519.cloudfront.net/485674b133dc2f1d66d20c9d52c62bec/original.jpg',
  'https://d38eepresuu519.cloudfront.net/3977d2a47b584820969e2acf4d923e33/original.jpg'
])

# Find images using their hash values:
ad_images = account.ad_images(hashes: ad_images.map(&:hash))

# Destroy images:
ad_images.map(&:destroy)
```

### [Ad Creatives](https://developers.facebook.com/docs/marketing-api/reference/ad-creative) (Fetch, Find, Create, Destroy)

```ruby
# Fetch all creatives owned by an account:
ad_creatives = account.ad_creatives

# Create two images that we'll use in our creatives:
ad_images = account.create_ad_images([
  'https://d38eepresuu519.cloudfront.net/485674b133dc2f1d66d20c9d52c62bec/original.jpg',
  'https://d38eepresuu519.cloudfront.net/3977d2a47b584820969e2acf4d923e33/original.jpg'
])

# Create a carousel creative driving installs for an Android app:
carousel_ad_creative = account.create_ad_creative({
  name: 'Test Carousel Creative',
  page_id: '300664329976860', # Add your Facebook Page ID here.
  link: 'http://play.google.com/store/apps/details?id=com.tophatter', # Add your Play Store ID here.
  message: 'A message.',
  assets: [
    { hash: ad_images.first.hash, title: 'Image #1 Title' },
    { hash: ad_images.second.hash, title: 'Image #2 Title' }
  ],
  call_to_action_type: 'SHOP_NOW', # See FacebookAds::AdCreative::CALL_TO_ACTION_TYPES for a list of all call to action types.
  multi_share_optimized: true,
  multi_share_end_card: false
}, carousel: true)

# Create a single image creative advertising an Android app:
image_ad_creative = account.create_ad_creative({
  name: 'Test Single Image Creative',
  page_id: '300664329976860', # Add your Facebook Page ID here.
  message: 'A message.',
  link: 'http://play.google.com/store/apps/details?id=com.tophatter', # Add your Play Store ID here.
  link_title: 'A link title.',
  image_hash: ad_images.first.hash,
  call_to_action_type: 'SHOP_NOW'
}, carousel: false)

# The options will be different depending on the thing being advertised (Android app, iOS app or website).

# Find a creative by ID:
carousel_ad_creative = FacebookAds::AdCreative.find(carousel_ad_creative.id)

# Destroy a creative:
carousel_ad_creative.destroy
image_ad_creative.destroy
```

### [Ad Sets](https://developers.facebook.com/docs/marketing-api/reference/ad-campaign) (Fetch, Find, Create, Destroy)

```ruby
# You interact with ad sets via a campaign:
campaign = account.campaigns(effective_status: nil).first

# Fetch all active ad sets for a campaign:
ad_sets = campaign.ad_sets

# Fetch all paused ad sets for a campaign (can pass multiple statuses in the array):
ad_sets = campaign.ad_sets(effective_status: ['PAUSED']) # See FacebookAds::AdSet::STATUSES for a list of all statuses.

# Fetch all ad sets for a campaign:
ad_sets = campaign.ad_sets(effective_status: nil)

# Specify the audience targeted by this ad set (https://developers.facebook.com/docs/marketing-api/targeting-specs):
targeting                   = FacebookAds::TargetingSpec.new
targeting.genders           = [FacebookAds::TargetingSpec::WOMEN]
targeting.age_min           = 29
targeting.age_max           = 65
targeting.countries         = ['US']
targeting.user_os           = [FacebookAds::TargetingSpec::ANDROID_OS]
targeting.user_device       = FacebookAds::TargetingSpec::ANDROID_DEVICES
targeting.app_install_state = FacebookAds::TargetingSpec::NOT_INSTALLED
targeting.validate!

# Create an ad set to drive installs to an Android app using the targeting above:
ad_set = campaign.create_ad_set(
  name: 'Test Ad Set',
  targeting: targeting,
  promoted_object: { # This can be an Android app, iOS app or pixel ID, plus an optional custom event.
    application_id: '295802707128640',
    object_store_url: 'http://play.google.com/store/apps/details?id=com.tophatter',
    custom_event_type: 'PURCHASE'
  },
  optimization_goal: 'OFFSITE_CONVERSIONS', # See FacebookAds::AdSet::OPTIMIZATION_GOALS.
  daily_budget: 500, # This is in cents, so the daily budget here is $5.
  billing_event: 'IMPRESSIONS', # See FacebookAds::AdSet::BILLING_EVENTS for a list of all billing events.
  status: 'PAUSED'
)

# Find an ad set by ID:
ad_set = FacebookAds::AdSet.find(ad_set.id)

# Destroy an ad set:
ad_set.destroy
```

### [Ads](https://developers.facebook.com/docs/marketing-api/reference/adgroup)

```ruby
# You interact with ads via an ad set:
account = FacebookAds::AdAccount.find_by(name: 'ReFuel4')
ad_set = account.campaigns(effective_status: nil).first.ad_sets(effective_status: nil).first

# Fetch all active ads for an ad set:
ads = ad_set.ads

# Fetch all paused ads for an ad set (can pass multiple statuses in the array):
ads = ad_set.ads(effective_status: ['PAUSED']) # See FacebookAds::Ad::STATUSES for a list of all statuses.

# Fetch all ads for an ad set:
ads = ad_set.ads(effective_status: nil)

# Fetch a creative that we'll use to create an ad:
ad_creative = account.ad_creatives.first

# Create an ad:
ad = ad_set.create_ad(name: 'Test Ad', creative_id: ad_creative.id)

# Find an ad by ID:
ad = FacebookAds::Ad.find(ad.id)

# Destroy an ad:
ad.destroy
```

### [Ad Insights](https://developers.facebook.com/docs/marketing-api/insights/overview)

```ruby
```

### Fetch All Objects

```ruby
campaigns = account.campaigns(effective_status: nil)
ad_images = account.ad_images
ad_creatives = account.ad_creatives
ad_sets = campaigns.map { |campaign| campaign.ad_sets(effective_status: nil) }.flatten
```
