module FacebookAds
  # The base class for all ads objects.
  class Base < Hashie::Mash
    class << self
      def find(id)
        get("/#{id}", objectify: true)
      end

      def get(path, query: {}, objectify:)
        query = pack(query, objectify) # Adds access token, fields, etc.
        uri = "#{FacebookAds.base_uri}#{path}?" + build_nested_query(query)
        FacebookAds.logger.debug "GET #{uri}"
        response = begin
          RestClient.get(uri)
        rescue RestClient::Exception => e
          exception(:get, path, e)
        end
        unpack(response, objectify: objectify)
      end

      def post(path, query: {}, objectify:)
        query = pack(query, objectify)
        uri = "#{FacebookAds.base_uri}#{path}"
        FacebookAds.logger.debug "POST #{uri} #{query}"
        response = begin
          RestClient.post(uri, query)
        rescue RestClient::Exception => e
          exception(:post, path, e)
        end
        unpack(response, objectify: objectify)
      end

      def delete(path, query: {})
        query = pack(query, false)
        uri = "#{FacebookAds.base_uri}#{path}?" + build_nested_query(query)
        FacebookAds.logger.debug "DELETE #{uri}"
        response = begin
          RestClient.delete(uri)
        rescue RestClient::Exception => e
          exception(:delete, path, e)
        end
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
            response = begin
              RestClient.get(url)
            rescue RestClient::Exception => e
              exception(:get, url, e)
            end
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

      def escape(s)
        URI.encode_www_form_component(s)
      end

      # https://github.com/rack/rack/blob/master/lib/rack/utils.rb
      def build_nested_query(value, prefix = nil)
        case value
        when Array
          value.map { |v| build_nested_query(v, "#{prefix}[]") }.join('&')
        when Hash
          value.map { |k, v| build_nested_query(v, prefix ? "#{prefix}[#{escape(k)}]" : escape(k)) }.reject(&:empty?).join('&')
        when nil
          prefix
        else
          raise ArgumentError, 'value must be a Hash' if prefix.nil?
          "#{prefix}=#{escape(value)}"
        end
      end

      def exception(verb, path, e)
        if e.response.is_a?(String)
          begin
            hash    = JSON.parse(e.response)
            error   = hash['error']
            message = error.nil? ? hash.inspect : "#{error['type']} code=#{error['code']} message=#{error['message']}"
          rescue JSON::ParserError
            message = e.response.first(100)
          end
        else
          message = e.response.inspect
        end

        FacebookAds.logger.error "#{verb.upcase} #{path} [#{e.message}] #{message}"
        raise e
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
