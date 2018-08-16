# frozen_string_literal: true

# External requires.
require 'json'
require 'rest-client'
require 'hashie'
require 'logger'
require 'openssl'

# Internal requires.
require 'facebook_ads/base'
Dir[File.expand_path('../facebook_ads/*.rb', __FILE__)].each { |f| require f }

# The primary namespace for this gem.
module FacebookAds
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
    @base_uri = "https://graph.facebook.com/v#{api_version}" unless defined?(@base_uri)
    @base_uri
  end

  def self.api_version=(api_version)
    @api_version = api_version
  end

  def self.api_version
    @api_version = '3.1' unless defined?(@api_version)
    @api_version
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
end
