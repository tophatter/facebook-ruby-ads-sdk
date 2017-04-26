FacebookAds.business_id  = '760977220612233'
FacebookAds.access_token = ENV['FACEBOOK_ACCESS_TOKEN'] || 'fake-facebook-access-token'
FacebookAds.logger       = Logger.new(STDOUT)
FacebookAds.logger.level = Logger::Severity::DEBUG
