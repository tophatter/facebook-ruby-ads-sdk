# frozen_string_literal: true

FacebookAds.business_id  = '760977220612233'
FacebookAds.access_token = ENV['FACEBOOK_ACCESS_TOKEN'] || 'fake-facebook-access-token'
FacebookAds.app_secret   = ENV['FACEBOOK_APP_SECRET']   || 'fake-facebook-app-secret'
FacebookAds.api_version  = '2.9'
# FacebookAds.logger       = Logger.new(STDOUT)
# FacebookAds.logger.level = Logger::Severity::DEBUG
