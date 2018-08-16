# frozen_string_literal: true

module FacebookAds
  # https://developers.facebook.com/docs/marketing-api/targeting-specs
  class AdTargeting
    MEN                = 1
    WOMEN              = 2
    GENDERS            = [MEN, WOMEN].freeze
    ANDROID_OS         = 'Android'
    APPLE_OS           = 'iOS'
    OSES               = [ANDROID_OS, APPLE_OS].freeze
    ANDROID_DEVICES    = %w[Android_Smartphone Android_Tablet].freeze
    APPLE_DEVICES      = %w[iPhone iPad iPod].freeze
    DEVICES            = ANDROID_DEVICES + APPLE_DEVICES
    INSTALLED          = 'installed'
    NOT_INSTALLED      = 'not_installed'
    APP_INSTALL_STATES = [INSTALLED, NOT_INSTALLED].freeze

    attr_accessor :genders, :age_min, :age_max, :countries, :user_os, :user_device, :app_install_state, :custom_locations, :income

    def initialize
      # self.genders = [WOMEN] # If nil, defaults to all genders.
      # self.age_min = 18 # If nil, defaults to 18.
      # self.age_max = 65 # If nil, defaults to 65+.
      # self.user_os = [ANDROID_OS]
      # self.user_device = ANDROID_DEVICES
      # self.app_install_state = NOT_INSTALLED
      self.income = [] # An a rray of objects with 'id' and optional 'name'
    end

    def geo_locations
      if custom_locations
        { custom_locations: custom_locations }
      elsif countries
        { countries: countries }
      else
        { countries: ['US'] }
      end
    end

    def validate!
      { gender: genders, countries: countries, user_os: user_os, user_device: user_device, custom_locations: custom_locations }.each_pair do |key, array|
        if !array.nil? && !array.is_a?(Array)
          raise Exception, "#{self.class.name}: #{key} must be an array"
        end
      end

      { genders: [genders, GENDERS], user_os: [user_os, OSES], user_device: [user_device, DEVICES] }.each_pair do |key, provided_and_acceptable|
        provided, acceptable = provided_and_acceptable

        if !provided.nil? && !(invalid = provided.detect { |value| !acceptable.include?(value) }).nil?
          raise Exception, "#{self.class.name}: #{invalid} is an invalid #{key}"
        end
      end

      true
    end

    def to_hash
      {
        genders: genders,
        age_min: age_min,
        age_max: age_max,
        geo_locations: geo_locations,
        user_os: user_os,
        user_device: user_device,
        app_install_state: app_install_state,
        income: income
      }.reject { |_k, v| v.nil? }
    end
  end
end
