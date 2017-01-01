module FacebookAds
  # The base class for all ads objects.
  class Base < Hashie::Mash
    class << self
      def find(id)
        get("/#{id}", objectify: true)
      end

      def get(path, query: {}, objectify:)
        query = pack(query, objectify) # Adds access token, fields, etc.
        FacebookAds.logger.debug "GET #{FacebookAds.base_uri}#{path}?#{query}"
        response = RestClient::Request.execute(method: :get, url: "#{FacebookAds.base_uri}#{path}", headers: { params: query })
        unpack(response, objectify: objectify)
      end

      def post(path, query: {}, objectify:)
        query = pack(query, objectify)
        FacebookAds.logger.debug "POST #{FacebookAds.base_uri}#{path}?#{query}"
        response = RestClient.post("#{FacebookAds.base_uri}#{path}", query)
        unpack(response, objectify: objectify)
      end

      def delete(path, query: {})
        query = pack(query, false)
        FacebookAds.logger.debug "DELETE #{FacebookAds.base_uri}#{path}?#{query}"
        response = RestClient::Request.execute(method: :delete, url: "#{FacebookAds.base_uri}#{path}", headers: { params: query })
        unpack(response, objectify: false)
      end

      def paginate(path, query: {})
        query[:limit] ||= 100
        limit = query[:limit]
        response = get(path, query: query.merge(fields: self::FIELDS.join(',')), objectify: false)
        data = response['data'].nil? ? [] : response['data']

        if data.length == limit
          while !(paging = response['paging']).nil? && !(url = paging['next']).nil?
            FacebookAds.logger.debug "GET #{url}"
            response = RestClient.get(url) # This should be raw since the URL has the host already.
            response = unpack(response, objectify: false)
            data += response['data'] unless response['data'].nil?
          end
        end

        if data.nil?
          []
        else
          data.map { |hash| instantiate(hash) }
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
        hash.delete_if { |_k, v| v.nil? }
      end

      def unpack(response, objectify:)
        raise Exception, 'Invalid nil response' if response.nil?

        response = response.body if response.is_a?(RestClient::Response)

        if response.is_a?(String)
          response = begin
            JSON.parse(response)
          rescue JSON::ParserError
            raise Exception, "Invalid JSON response: #{response.inspect}"
          end
        end

        raise Exception, "Invalid response: #{response.inspect}" unless response.is_a?(Hash)
        raise Exception, "[#{response['error']['code']}] #{response['error']['message']} - raw response: #{response.inspect}" unless response['error'].nil?
        return response unless objectify

        if response.key?('data') && (data = response['data']).is_a?(Array)
          data.map { |hash| instantiate(hash) }
        else
          instantiate(response)
        end
      end
    end

    def update(data)
      return false if data.nil?
      response = self.class.post("/#{id}", query: data, objectify: false)
      raise Exception, "Invalid response from update: #{response.inspect}" unless @response.is_a?(Hash) && response.key?('success')
      response['success']
    end

    def save
      return nil if changes.nil? || changes.length.zero?
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
      !id.nil?
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
