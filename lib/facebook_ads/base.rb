module FacebookAds
  class Base < Hashie::Mash

    class << self

      def find(id)
        get("/#{id}", objectify: true)
      end

      def get(path, query: {}, objectify:)
        query = pack(query, objectify) # Adds access token, fields, etc.
        FacebookAds.logger.debug "GET #{FacebookAds.base_uri}#{path}?#{query.to_query}"
        response = HTTParty.get("#{FacebookAds.base_uri}#{path}", query: query).parsed_response
        response = unpack(response, objectify: objectify)
      end

      def post(path, query: {}, objectify:)
        query = pack(query, objectify)
        FacebookAds.logger.debug "POST #{FacebookAds.base_uri}#{path}?#{query.to_query}"
        response = HTTMultiParty.post("#{FacebookAds.base_uri}#{path}", query: query).parsed_response
        response = unpack(response, objectify: objectify)
      end

      def delete(path, query: {})
        query = pack(query, false)
        FacebookAds.logger.debug "DELETE #{FacebookAds.base_uri}#{path}?#{query.to_query}"
        response = HTTParty.delete("#{FacebookAds.base_uri}#{path}", query: query).parsed_response
        response = unpack(response, objectify: false)
      end

      def paginate(path, query: {})
        response = get(path, query: query.merge(fields: self::FIELDS.join(',')), objectify: false)
        data = response['data'].present? ? response['data'] : []

        while (paging = response['paging']).present? && (url = paging['next']).present?
          FacebookAds.logger.debug "GET #{url}"
          response = HTTParty.get(url).parsed_response # This should be raw since the URL has the host already.
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
          object.send("#{key}=", value)
        end

        object
      end

      def pack(hash, objectify)
        hash = hash.merge(access_token: FacebookAds.access_token)
        hash = hash.merge(fields: self::FIELDS.join(',')) if objectify
        hash.compact
      end

      def unpack(response, objectify:)
        if response.nil? || !response.is_a?(Hash)
          raise Exception, "Invalid response: #{response.inspect}"
        end

        if response['error'].present?
          # Let's have different Exception subclasses for different error codes.
          raise Exception, "#{response['error']['code']}: #{response['error']['message']} | #{response.inspect}"
        end

        if objectify
          if response.key?('data') && (data = response['data']).is_a?(Array)
            data.map { |hash| instantiate(hash) }
          else
            instantiate(response)
          end
        else
          response
        end
      end

    end

    def update(data)
      if data.present?
        response = self.class.post("/#{id}", query: data, objectify: false)

        if response.is_a?(Hash) && response.key?('success')
          response['success']
        else
          raise Exception, "Invalid response from update: #{response.inspect}"
        end
      else
        false
      end
    end

    def save
      if changes.present?
        data = {}
        changes.keys.each { |key| data[key] = self[key] }

        if update(data)
          self.class.find(id)
        else
          nil
        end
      else
        nil
      end
    end

    def destroy(path: nil, query: {})
      response = self.class.delete(path || "/#{id}", query: query)

      if response.key?('success')
        response['success']
      else
        raise Exception, "Invalid response from destroy: #{response.inspect}"
      end
    end

    protected

    attr_accessor :changes

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
