# frozen_string_literal: true

require 'coveralls'
Coveralls.wear!

require 'awesome_print'
require 'facebook_ads'

Dir[File.expand_path(File.join(File.dirname(__FILE__), 'support', '**', '*.rb'))].each { |f| require f }
