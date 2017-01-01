ENV['RAILS_ENV'] ||= 'test'

require 'coveralls'
Coveralls.wear!('rails')

# https://github.com/colszowka/simplecov
require 'simplecov'
SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'bin/console'
end

require 'facebook_ads'
require 'minitest/autorun'
require 'vcr'
require 'awesome_print'

VCR.configure do |config|
  config.cassette_library_dir = 'test/vcr_cassettes'
  config.hook_into :webmock
  config.filter_sensitive_data('TEST_ACCESS_TOKEN') { File.read('test_access_token').chop }
end

class BaseTest < Minitest::Test
  protected

  def setup
    FacebookAds.access_token = begin
      File.read('test_access_token').chop
    rescue Errno::ENOENT
      'TEST_ACCESS_TOKEN'
    end

    FacebookAds.business_id = begin
      File.read('test_business_id').chop
    rescue Errno::ENOENT
      'TEST_BUSINESS_ID'
    end

    # FacebookAds.logger = Logger.new(STDOUT)
    # FacebookAds.logger.level = Logger::Severity::DEBUG
  end

  def vcr
    calling_method = caller[0][/`.*'/][1..-2]

    VCR.use_cassette("#{self.class.name}-#{calling_method}") do
      yield
    end
  end
end
