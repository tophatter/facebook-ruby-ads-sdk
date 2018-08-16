# frozen_string_literal: true

module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/reference/ad-account
  class AdAccount < Base
    FIELDS = %w[id account_id account_status age created_time currency name].freeze

    class << self
      def all(query = {})
        get('/me/adaccounts', query: query, objectify: true)
      end
    end

    # AdvertisableApplication

    def advertisable_applications(limit: 100)
      AdvertisableApplication.paginate("/#{id}/advertisable_applications", query: { limit: limit })
    end

    # AdUser

    def ad_users(limit: 100)
      AdCampaign.paginate("/#{id}/users", query: { limit: limit })
    end

    # AdCampaign

    def ad_campaigns(effective_status: ['ACTIVE'], limit: 100)
      AdCampaign.paginate("/#{id}/campaigns", query: { effective_status: effective_status, limit: limit })
    end

    def create_ad_campaign(name:, objective:, status: 'ACTIVE')
      raise Exception, "Objective must be one of: #{AdCampaign::OBJECTIVES.join(', ')}" unless AdCampaign::OBJECTIVES.include?(objective)
      raise Exception, "Status must be one of: #{AdCampaign::STATUSES.join(', ')}" unless AdCampaign::STATUSES.include?(status)
      query = { name: name, objective: objective, status: status }
      result = AdCampaign.post("/#{id}/campaigns", query: query)
      AdCampaign.find(result['id'])
    end

    def create_dynamic_ad_campaign(name:, product_catalog_id:, status: 'ACTIVE')
      raise Exception, "Status must be one of: #{AdCampaign::STATUSES.join(', ')}" unless AdCampaign::STATUSES.include?(status)
      query = { name: name, objective: 'PRODUCT_CATALOG_SALES', status: status, promoted_object: { product_catalog_id: product_catalog_id } }
      result = AdCampaign.post("/#{id}/campaigns", query: query)
      AdCampaign.find(result['id'])
    end

    # AdSet

    def ad_sets(effective_status: ['ACTIVE'], limit: 100)
      AdSet.paginate("/#{id}/adsets", query: { effective_status: effective_status, limit: limit })
    end

    # Ad

    def ads(effective_status: ['ACTIVE'], limit: 100)
      Ad.paginate("/#{id}/ads", query: { effective_status: effective_status, limit: limit })
    end

    # AdImage

    def ad_images(hashes: nil, limit: 100)
      if !hashes.nil?
        AdImage.get("/#{id}/adimages", query: { hashes: hashes }, objectify: true)
      else
        AdImage.paginate("/#{id}/adimages", query: { limit: limit })
      end
    end

    def create_ad_images(urls)
      files = urls.map do |url|
        name, path = download(url)
        [name, File.open(path)]
      end.to_h

      response = AdImage.post("/#{id}/adimages", query: files)
      files.values.each { |file| File.delete(file.path) }
      !response['images'].nil? ? ad_images(hashes: response['images'].map { |_key, hash| hash['hash'] }) : []
    end

    # AdCreative

    def ad_creatives(limit: 100)
      AdCreative.paginate("/#{id}/adcreatives", query: { limit: limit })
    end

    def create_ad_creative(creative, creative_type: nil, carousel: false)
      # Support old deprecated carousel param
      return create_carousel_ad_creative(creative) if carousel
      case creative_type
      when 'carousel'
        create_carousel_ad_creative(creative)
      when 'link'
        create_link_ad_creative(creative)
      when 'image'
        create_image_ad_creative(creative)
      else
        create_image_ad_creative(creative)
      end
    end

    # AdAudience

    def ad_audiences(limit: 100)
      AdAudience.paginate("/#{id}/customaudiences", query: { limit: limit })
    end

    def create_ad_audience_with_pixel(name:, pixel_id:, event_name:, subtype: 'WEBSITE', retention_days: 15)
      query = {
        name: name,
        pixel_id: pixel_id,
        subtype: subtype,
        retention_days: retention_days,
        rule: { event: { i_contains: event_name } }.to_json,
        prefill: 1
      }

      result = AdAudience.post("/#{id}/customaudiences", query: query)
      AdAudience.find(result['id'])
    end

    # AdInsight

    def ad_insights(range: Date.today..Date.today, level: 'ad', time_increment: 1)
      ad_campaigns.map do |ad_campaign|
        ad_campaign.ad_insights(range: range, level: level, time_increment: time_increment)
      end.flatten
    end

    def reach_estimate(targeting:, optimization_goal:, currency: 'USD')
      raise Exception, "Optimization goal must be one of: #{AdSet::OPTIMIZATION_GOALS.join(', ')}" unless AdSet::OPTIMIZATION_GOALS.include?(optimization_goal)

      if targeting.is_a?(AdTargeting)
        if targeting.validate!
          targeting = targeting.to_hash
        else
          raise Exception, 'The provided targeting spec is not valid.'
        end
      end

      query = {
        targeting_spec: targeting.to_json,
        optimize_for: optimization_goal,
        currency: currency
      }

      self.class.get("/#{id}/reachestimate", query: query, objectify: false)
    end

    def delivery_estimate(targeting:, optimization_goal:, currency: 'USD')
      raise Exception, "Optimization goal must be one of: #{AdSet::OPTIMIZATION_GOALS.join(', ')}" unless AdSet::OPTIMIZATION_GOALS.include?(optimization_goal)

      if targeting.is_a?(AdTargeting)
        if targeting.validate!
          targeting = targeting.to_hash
        else
          raise Exception, 'The provided targeting spec is not valid.'
        end
      end

      query = {
        targeting_spec: targeting.to_json,
        optimization_goal: optimization_goal,
        currency: currency
      }

      self.class.get("/#{id}/delivery_estimate", query: query, objectify: false)
    end

    private

    def create_carousel_ad_creative(creative)
      required = %i[name page_id link message assets call_to_action_type multi_share_optimized multi_share_end_card]

      unless (keys = required - creative.keys).length.zero?
        raise Exception, "Creative is missing the following: #{keys.join(', ')}"
      end

      raise Exception, "Creative call_to_action_type must be one of: #{AdCreative::CALL_TO_ACTION_TYPES.join(', ')}" unless AdCreative::CALL_TO_ACTION_TYPES.include?(creative[:call_to_action_type])

      query = if creative[:product_set_id].present?
        AdCreative.product_set(
          name: creative[:name],
          page_id: creative[:page_id],
          link: creative[:link],
          message: creative[:message],
          headline: creative[:headline],
          description: creative[:description],
          product_set_id: creative[:product_set_id]
        )
      else
        AdCreative.carousel(creative)
      end

      result = AdCreative.post("/#{id}/adcreatives", query: query)
      AdCreative.find(result['id'])
    end

    def create_image_ad_creative(creative)
      required = %i[name page_id message link link_title image_hash call_to_action_type]

      unless (keys = required - creative.keys).length.zero?
        raise Exception, "Creative is missing the following: #{keys.join(', ')}"
      end

      raise Exception, "Creative call_to_action_type must be one of: #{AdCreative::CALL_TO_ACTION_TYPES.join(', ')}" unless AdCreative::CALL_TO_ACTION_TYPES.include?(creative[:call_to_action_type])
      query = AdCreative.photo(creative)
      result = AdCreative.post("/#{id}/adcreatives", query: query)
      AdCreative.find(result['id'])
    end

    def create_link_ad_creative(creative)
      required = %i[name title body object_url link_url image_hash page_id]

      unless (keys = required - creative.keys).length.zero?
        raise Exception, "Creative is missing the following: #{keys.join(', ')}"
      end

      query = AdCreative.link(creative)
      result = AdCreative.post("/#{id}/adcreatives", query: query)
      AdCreative.find(result['id'])
    end

    def download(url)
      pathname = Pathname.new(url)
      name = "#{pathname.dirname.basename}.jpg"
      # @FIXME: Need to handle exception here.
      data = RestClient.get(url).body
      file = File.open("/tmp/#{name}", 'w') # Assume *nix-based system.
      file.binmode
      file.write(data)
      file.close
      [name, file.path]
    end
  end
end
