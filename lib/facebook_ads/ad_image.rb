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

    def destroy
      response = self.class.delete!("/act_#{account_id}/adimages", query: { hash: hash })

      if response.key?('success')
        response['success']
      else
        raise Exception, "Invalid response from DELETE operation: #{response.inspect}"
      end
    end

  end
end
