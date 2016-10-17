module FacebookAds
  # An ad account has many ad campaigns, ad images, and ad creatives.
  # https://developers.facebook.com/docs/marketing-api/reference/ad-account
  class AdAccount < Base
    FIELDS = %w(id account_id account_status age created_time currency name last_used_time).freeze

    class << self
      def all
        get('/me/adaccounts', objectify: true)
      end

      def find_by(conditions)
        all.detect do |ad_account|
          conditions.all? do |key, value|
            ad_account.send(key) == value
          end
        end
      end
    end

    # has_many campaigns

    def ad_campaigns(effective_status: ['ACTIVE'], limit: 100)
      FacebookAds::AdCampaign.paginate("/#{id}/campaigns", query: { effective_status: effective_status, limit: limit })
    end

    def create_ad_campaign(name:, objective:, status: 'ACTIVE')
      raise Exception, "Objective must be one of: #{FacebookAds::AdCampaign::OBJECTIVES.to_sentence}" unless FacebookAds::AdCampaign::OBJECTIVES.include?(objective)
      raise Exception, "Status must be one of: #{FacebookAds::AdCampaign::STATUSES.to_sentence}" unless FacebookAds::AdCampaign::STATUSES.include?(status)
      campaign = FacebookAds::AdCampaign.post("/#{id}/campaigns", query: { name: name, objective: objective, status: status }, objectify: true)
      FacebookAds::AdCampaign.find(campaign.id)
    end

    # has_many ad_images

    def ad_images(hashes: nil, limit: 100)
      if hashes.present?
        FacebookAds::AdImage.get("/#{id}/adimages", query: { hashes: hashes }, objectify: true)
      else
        FacebookAds::AdImage.paginate("/#{id}/adimages", query: { limit: limit })
      end
    end

    def create_ad_images(urls)
      files = urls.map do |url|
        name, path = download(url)
        [name, File.open(path)]
      end.to_h

      response = FacebookAds::AdImage.post("/#{id}/adimages", query: files, objectify: false)
      files.values.each { |file| File.delete(file.path) }
      response['images'].present? ? ad_images(hashes: response['images'].map { |_key, hash| hash['hash'] }) : []
    end

    # has_many ad_creatives

    def ad_creatives(limit: 100)
      FacebookAds::AdCreative.paginate("/#{id}/adcreatives", query: { limit: limit })
    end

    def create_ad_creative(creative, carousel: true)
      carousel ? create_carousel_ad_creative(creative) : create_image_ad_creative(creative)
    end

    # has_many ad_sets

    def ad_sets(effective_status: ['ACTIVE'], limit: 100)
      FacebookAds::AdSet.paginate("/#{id}/adsets", query: { effective_status: effective_status, limit: limit })
    end

    # has_many ads

    def ads(effective_status: ['ACTIVE'], limit: 100)
      FacebookAds::Ad.paginate("/#{id}/ads", query: { effective_status: effective_status, limit: limit })
    end

    # has_many ad_insights

    def ad_insights(range: Date.today..Date.today, level: 'ad', time_increment: 1)
      ad_campaigns.map do |ad_campaign|
        ad_campaign.ad_insights(range: range, level: level, time_increment: time_increment)
      end.flatten
    end

    # has_many applications

    def applications
      self.class.get("/#{id}/advertisable_applications", objectify: false)
    end

    private

    def create_carousel_ad_creative(creative)
      required = %i(name page_id link message assets call_to_action_type multi_share_optimized multi_share_end_card)

      if (keys = required - creative.keys).present?
        raise Exception, "Creative is missing the following: #{keys.to_sentence}"
      end

      raise Exception, "Creative call_to_action_type must be one of: #{FacebookAds::AdCreative::CALL_TO_ACTION_TYPES.to_sentence}" unless FacebookAds::AdCreative::CALL_TO_ACTION_TYPES.include?(creative[:call_to_action_type])
      query = FacebookAds::AdCreative.carousel(creative)
      creative = FacebookAds::AdCreative.post("/#{id}/adcreatives", query: query, objectify: true) # Returns a FacebookAds::AdCreative instance.
      FacebookAds::AdCreative.find(creative.id)
    end

    def create_image_ad_creative(creative)
      required = %i(name page_id message link link_title image_hash call_to_action_type)

      if (keys = required - creative.keys).present?
        raise Exception, "Creative is missing the following: #{keys.to_sentence}"
      end

      raise Exception, "Creative call_to_action_type must be one of: #{FacebookAds::AdCreative::CALL_TO_ACTION_TYPES.to_sentence}" unless FacebookAds::AdCreative::CALL_TO_ACTION_TYPES.include?(creative[:call_to_action_type])
      query = FacebookAds::AdCreative.photo(creative)
      creative = FacebookAds::AdCreative.post("/#{id}/adcreatives", query: query, objectify: true) # Returns a FacebookAds::AdCreative instance.
      FacebookAds::AdCreative.find(creative.id)
    end

    def download(url)
      pathname = Pathname.new(url)
      name = "#{pathname.dirname.basename}.jpg"
      data = HTTParty.get(url).body
      file = File.open("/tmp/#{name}", 'w') # Assume *nix-based system.
      file.binmode
      file.write(data)
      file.close
      [name, file.path]
    end
  end
end
