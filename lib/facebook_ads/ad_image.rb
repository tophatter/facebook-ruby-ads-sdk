module FacebookAds
  # An ad image belongs to an ad account.
  # An image will always produce the same hash.
  # https://developers.facebook.com/docs/marketing-api/reference/ad-image
  class AdImage < Base
    FIELDS = %w[id hash account_id name permalink_url original_width original_height].freeze

    class << self
      def find(_id)
        raise Exception, 'NOT IMPLEMENTED'
      end
    end

    # @TODO:
    # You are setting a key that conflicts with a built-in method FacebookAds::AdImage#hash defined in Hash.
    # This can cause unexpected behavior when accessing the key via as a property.
    # You can still access the key via the #[] method.
    def hash
      self[:hash]
    end

    def update(_data)
      raise Exception, 'NOT IMPLEMENTED'
    end

    def destroy
      super(path: "/act_#{account_id}/adimages", query: { hash: self[:hash] })
    end
  end
end
