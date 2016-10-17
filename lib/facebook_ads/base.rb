module FacebookAds
  # The base class for all ads objects.
  class Base < Hashie::Mash
    class << self
      def find(id)
        get("/#{id}", objectify: true)
      end

      def get(path, query: {}, objectify:)
        query = pack(query, objectify) # Adds access token, fields, etc.
        FacebookAds.logger.debug "GET #{FacebookAds.base_uri}#{path}?#{query.to_query}"
        response = HTTParty.get("#{FacebookAds.base_uri}#{path}", query: query, timeout: 30).parsed_response
        unpack(response, objectify: objectify)
      end

      def post(path, query: {}, objectify:)
        query = pack(query, objectify)
        FacebookAds.logger.debug "POST #{FacebookAds.base_uri}#{path}?#{query.to_query}"
        response = HTTMultiParty.post("#{FacebookAds.base_uri}#{path}", query: query).parsed_response
        unpack(response, objectify: objectify)
      end

      def delete(path, query: {})
        query = pack(query, false)
        FacebookAds.logger.debug "DELETE #{FacebookAds.base_uri}#{path}?#{query.to_query}"
        response = HTTParty.delete("#{FacebookAds.base_uri}#{path}", query: query).parsed_response
        unpack(response, objectify: false)
      end

      def paginate(path, query: {})
        response = get(path, query: query.merge(fields: self::FIELDS.join(',')), objectify: false)
        data = response['data'].present? ? response['data'] : []

        while (paging = response['paging']).present? && (url = paging['next']).present?
          FacebookAds.logger.debug "GET #{url}"
          response = HTTParty.get(url).parsed_response # This should be raw since the URL has the host already.
          response = unpack(response, objectify: false)
          data += response['data'] if response['data'].present?
        end

        if data.present?
          data.map { |hash| instantiate(hash) }
        else
          []
        end
      end

      private

      def instantiate(hash)
        object = new

        hash.each_pair do |key, value|
          # https://github.com/intridea/hashie/blob/master/lib/hashie/mash.rb#L111
          object.custom_writer(key, value, false)
        end

        object
      end

      def pack(hash, objectify)
        hash = hash.merge(access_token: FacebookAds.access_token)
        hash = hash.merge(fields: self::FIELDS.join(',')) if objectify
        hash.compact
      end

      def unpack(response, objectify:)
        raise Exception, 'Invalid nil response' if response.nil?

        # Certain errors won't get parsed by HTTParty#parsed_response.
        if response.is_a?(String)
          response = begin
            JSON.parse(response)
          rescue JSON::ParserError
            raise Exception, "Invalid JSON response: #{response.inspect}"
          end
        end

        raise Exception, "Invalid response: #{response.inspect}" unless response.is_a?(Hash)
        raise Exception, "[#{response['error']['code']}] #{response['error']['message']} - raw response: #{response.inspect}" if response['error'].present?
        return response unless objectify

        if response.key?('data') && (data = response['data']).is_a?(Array)
          data.map { |hash| instantiate(hash) }
        else
          instantiate(response)
        end
      end
    end

    def update(data)
      return false unless data.present?
      response = self.class.post("/#{id}", query: data, objectify: false)
      raise Exception, "Invalid response from update: #{response.inspect}" unless @response.is_a?(Hash) && response.key?('success')
      response['success']
    end

    def save
      return nil unless changes.present?
      data = {}
      changes.keys.each { |key| data[key] = self[key] }
      return nil unless update(data)
      self.class.find(id)
    end

    def destroy(path: nil, query: {})
      response = self.class.delete(path || "/#{id}", query: query)
      raise Exception, "Invalid response from destroy: #{response.inspect}" unless response.key?('success')
      response['success']
    end

    protected

    attr_accessor :changes

    def persisted?
      id.present?
    end

    private

    def []=(key, value)
      old_value = self[key]
      new_value = super(key, value)

      self.changes ||= {}

      if old_value != new_value
        self.changes[key] = [old_value, new_value]
      else
        self.changes.delete(key)
      end

      new_values
    end
  end
end
