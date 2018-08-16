# frozen_string_literal: true

module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/reference/product-catalog
  class AdProductCatalog < Base
    FIELDS = %w[id name vertical product_count feed_count].freeze

    class << self
      def all(query = {})
        get("/#{FacebookAds.business_id}/owned_product_catalogs", query: query, objectify: true)
      end

      def create(name:)
        query = { name: name }
        result = post("/#{FacebookAds.business_id}/owned_product_catalogs", query: query)
        find(result['id'])
      end
    end

    # has_many ad_product_feeds

    def ad_product_feeds
      AdProductFeed.paginate("/#{id}/product_feeds")
    end

    # catalog.create_ad_product_feed(name: 'Test', schedule: { url: 'https://tophatter.com/admin/ad_automation/ad_product_feeds/1.csv', interval: 'HOURLY' })
    def create_ad_product_feed(name:, schedule:)
      query = { name: name, schedule: schedule }
      result = AdProductCatalog.post("/#{id}/product_feeds", query: query)
      AdProductFeed.find(result['id'])
    end

    # catalog.create_ad_product_set(name: 'Ring Set', filter: {"category":{"i_contains":"Apparel & Accessories > Jewelry > Earrings"}})
    def create_ad_product_set(name:, filter:)
      query = { name: name, filter: filter.to_json }
      result = AdProductSet.post("/#{id}/product_sets", query: query)
      AdProductSet.find(result['id'])
    end

    # has_many product_groups

    def ad_product_groups
      AdProductGroup.paginate("/#{id}/product_groups")
    end

    # has_many product_sets

    def ad_product_sets
      AdProductSet.paginate("/#{id}/product_sets")
    end

    # has_many ad_products

    def ad_products
      AdProduct.paginate("/#{id}/products")
    end

    def create_ad_product(data)
      result = AdProductCatalog.post("/#{id}/products", query: data)
      AdProduct.find(result['id'])
    end
  end
end
