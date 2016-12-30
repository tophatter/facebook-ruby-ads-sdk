module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/reference/product-catalog
  class AdProductCatalog < Base
    FIELDS = %w(id name vertical product_count feed_count).freeze

    class << self
      def all
        get("/#{FacebookAds.business_id}/product_catalogs", objectify: true)
      end

      def create(name:)
        catalog = post("/#{FacebookAds.business_id}/product_catalogs", query: { name: name }, objectify: true)
        find(catalog.id)
      end
    end

    # has_many ad_product_feeds

    def ad_product_feeds
      AdProductFeed.paginate("/#{id}/product_feeds")
    end

    # catalog.create_ad_product_feed(name: 'Test', schedule: { url: 'https://tophatter.com/admin/ad_automation/ad_product_feeds/1.csv', interval: 'HOURLY' })
    def create_ad_product_feed(name:, schedule:)
      feed = AdProductCatalog.post("/#{id}/product_feeds", query: { name: name, schedule: schedule }, objectify: true)
      AdProductFeed.find(feed.id)
    end

    # has_many product_groups

    # def ad_product_groups
    #   AdProductGroup.paginate("/#{id}/product_groups")
    # end

    # has_many product_sets

    # def ad_product_sets
    #   AdProductSet.paginate("/#{id}/product_sets")
    # end

    # has_many ad_products

    def ad_products
      AdProduct.paginate("/#{id}/products")
    end

    def create_ad_product(data)
      product = AdProductCatalog.post("/#{id}/products", query: data, objectify: true)
      AdProduct.find(product.id)
    end
  end
end
