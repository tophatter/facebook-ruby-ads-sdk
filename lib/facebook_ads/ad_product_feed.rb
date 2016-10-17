module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/reference/product-feed
  class AdProductFeed < Base
    FIELDS = %w(id name).freeze
  end

  # has_many ad_product_feed_uploads

  def ad_product_feed_uploads
    AdProductFeedUpload.paginate("/#{id}/uploads")
  end

  def create_ad_product_feed_upload(data)
    query = data
    upload = AdProductFeed.post("/#{id}/uploads", query: query, objectify: true)
    AdProductFeedUpload.find(upload.id)
  end
end
