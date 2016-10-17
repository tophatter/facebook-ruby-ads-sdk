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
