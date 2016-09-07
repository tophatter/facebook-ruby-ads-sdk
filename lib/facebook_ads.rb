# External requires.
require 'active_support/all'
require 'httmultiparty'
require 'hashie'

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
    unless defined?(@base_uri)
      @base_uri = 'https://graph.facebook.com/v2.6'
    end

    @base_uri
  end

  def self.access_token=(access_token)
    @access_token = access_token
  end

  def self.access_token
    @access_token
  end

end
