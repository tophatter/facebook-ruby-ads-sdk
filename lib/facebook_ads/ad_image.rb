# https://developers.facebook.com/docs/marketing-api/reference/ad-image
module FacebookAds
  class AdImage < Base

    FIELDS = %w(id hash account_id name permalink_url original_width original_height)

    class << self
      def find(id)
        raise Exception, 'NOT IMPLEMENTED'
      end
    end

    def hash
      self[:hash]
    end

    def update(data)
      raise Exception, 'NOT IMPLEMENTED'
    end

    def destroy
      super(path: "/act_#{account_id}/adimages", query: { hash: hash })
    end

  end
end
