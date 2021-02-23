# frozen_string_literal: true

# External requires.
require 'json'
require 'rest-client'
require 'hashie'
require 'logger'
require 'openssl'

# Internal requires.
require 'facebook_ads/base'
require 'facebook_ads/account'
require 'facebook_ads/ad_account'
require 'facebook_ads/ad_audience'
require 'facebook_ads/ad_campaign'
require 'facebook_ads/ad_creative'
require 'facebook_ads/ad_exception'
require 'facebook_ads/ad_image'
require 'facebook_ads/ad_insight'
require 'facebook_ads/ad_product_catalog'
require 'facebook_ads/ad_product_feed'
require 'facebook_ads/ad_product'
require 'facebook_ads/ad_set_activity'
require 'facebook_ads/ad_set'
require 'facebook_ads/ad_targeting'
require 'facebook_ads/ad_user'
require 'facebook_ads/ad'
require 'facebook_ads/advertisable_application'

# The primary namespace for this gem.
module FacebookAds
  REQUEST_HEADERS   = { accept: :json, accept_encoding: :identity }.freeze
  RETRYABLE_ERRORS  = [RestClient::ExceptionWithResponse, Errno::ECONNRESET, Errno::ECONNREFUSED].freeze
  RETRY_LIMIT       = 10
  RECOVERABLE_CODES = [1, 2, 2601].freeze

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    unless defined?(@logger)
      @logger       = Logger.new('/dev/null')
      @logger.level = Logger::Severity::UNKNOWN
    end

    @logger
  end

  def self.base_uri=(base_uri)
    @base_uri = base_uri
  end

  def self.base_uri
    @base_uri ||= "https://graph.facebook.com/v#{api_version}"
  end

  def self.api_version=(api_version)
    @api_version = api_version
    @base_uri    = nil
  end

  def self.api_version
    @api_version ||= '8.0'
  end

  def self.access_token=(access_token)
    @access_token = access_token
  end

  def self.access_token
    @access_token
  end

  def self.app_secret=(app_secret)
    @app_secret = app_secret
  end

  def self.app_secret
    @app_secret
  end

  def self.appsecret_proof
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @app_secret, @access_token)
  end

  def self.business_id=(business_id)
    @business_id = business_id
  end

  def self.business_id
    @business_id
  end

  # Stubborn network calls.

  def self.stubbornly(retry_limit: RETRY_LIMIT, recoverable_codes: RECOVERABLE_CODES, debug: false)
    raise ArgumentError unless block_given?

    response    = nil
    retry_count = 0

    loop do
      response = yield
      break
    rescue *RETRYABLE_ERRORS => e
      if e.is_a?(RestClient::ExceptionWithResponse)
        error = begin
          JSON.parse(e.response)
        rescue JSON::ParserError
          nil
        end

        code = error&.[]('code')
        raise e if code && !recoverable_codes.include?(code)
      end

      raise e if retry_count >= retry_limit

      retry_count += 1
      wait = (retry_count**2) + 15 + (rand(15) * (retry_count + 1))
      puts "retry ##{retry_count} will start in #{wait}s" if debug
      sleep wait
    end

    response
  end

  def self.stubbornly_get(url, retry_limit: RETRY_LIMIT, recoverable_codes: RECOVERABLE_CODES, debug: false)
    stubbornly(retry_limit: retry_limit, recoverable_codes: recoverable_codes, debug: debug) do
      RestClient.get(url, REQUEST_HEADERS)
    end
  end

  def self.stubbornly_post(url, payload, retry_limit: RETRY_LIMIT, recoverable_codes: RECOVERABLE_CODES, debug: false)
    stubbornly(retry_limit: retry_limit, recoverable_codes: recoverable_codes, debug: debug) do
      RestClient.post(url, payload, REQUEST_HEADERS)
    end
  end
end
