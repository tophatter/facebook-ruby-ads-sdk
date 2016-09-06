# External requires.
require 'active_support/all'
require 'httmultiparty'
require 'hashie'

# Internal requires.
require 'facebook_ads/base'
Dir[File.expand_path('../facebook_ads/*.rb', __FILE__)].each { |f| require f }

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

  def self.access_token=(access_token)
    @access_token = access_token
  end

  def self.access_token
    @access_token
  end

end
