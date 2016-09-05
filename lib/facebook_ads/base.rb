module FacebookAds
  class Base < Hashie::Mash

    include HTTMultiParty

    base_uri 'https://graph.facebook.com/v2.6'

    class << self

      def find(id)
        get!("/#{id}", objectify: true)
      end

      protected

      # HTTMultiParty wrappers.

      def get!(path, query: {}, objectify: false, fields: true)
        query = query.merge(access_token: FacebookAds.access_token)
        query = query.merge(fields: self::FIELDS.join(',')) if fields
        query = query.compact
        puts "GET #{path} #{query.inspect}"
        response = get(path, query: query).parsed_response
        response = parse(response, objectify: objectify)
      end

      def post!(path, query: {}, objectify: true, fields: false)
        query = query.merge(access_token: FacebookAds.access_token)
        query = query.merge(fields: self::FIELDS.join(',')) if fields
        query = query.compact
        puts "POST #{path} #{query.inspect}"
        response = post(path, query: query).parsed_response
        response = parse(response, objectify: objectify)
      end

      def delete!(path, query: {})
        query = query.merge(access_token: FacebookAds.access_token)
        puts "DELETE #{path} #{query.inspect}"
        response = delete(path, query: query).parsed_response
        response = parse(response, objectify: false)
      end

      # Pagination helper.

      def paginate!(path, query: {})
        response = get!(path, query: query)
        data = response['data'].present? ? response['data'] : []

        while (paging = response['paging']).present? && (url = paging['next']).present?
          response = get(url)
          data += response['data'] if response['data'].present?
        end

        if data.present?
          data.map { |hash| new(hash) }
        else
          []
        end
      end

      private

      # Facebook Marketing API specific parsing for JSON responses.
      def parse(response, objectify:)
        response = response.is_a?(String) ? JSON.parse(response) : response

        if response['error'].present?
          # Let's have different Exception subclasses for different error codes.
          raise Exception, "#{response['error']['code']}: #{response['error']['message']} | #{response.inspect}"
        end

        if objectify
          if response.key?('data') && (data = response['data']).is_a?(Array)
            data.map { |hash| new(hash) }
          else
            new(response)
          end
        else
          response
        end
      end

    end

    attr_accessor :changes

    def initialize(data)
      data.each_pair do |key, value|
        self[key] = value
      end

      self.changes = {}
    end

    def update(data)
      if data.present?
        response = self.class.post!("/#{id}", query: data)

        if response.key?('success')
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
      response = self.class.delete!(path || "/#{id}", query: query)

      if response.key?('success')
        response['success']
      else
        raise Exception, "Invalid response from destroy: #{response.inspect}"
      end
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
