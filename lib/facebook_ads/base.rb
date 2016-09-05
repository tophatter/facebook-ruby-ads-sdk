module FacebookAds
  class Base < Hashie::Mash

    include HTTMultiParty

    base_uri 'https://graph.facebook.com/v2.6'

    class << self

      def find(id)
        get!("/#{id}", objectify: true)
      end

      # HTTMultiParty wrappers

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

    def initialize(data)
      data.each_pair do |key, value|
        self[key] = value
      end
    end

    def destroy
      response = self.class.delete!("/#{id}")

      if response.key?('success')
        response['success']
      else
        raise Exception, "Invalid response from DELETE operation: #{response.inspect}"
      end
    end

  end
end
