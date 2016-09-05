# https://developers.facebook.com/docs/marketing-api/targeting-specs
module FacebookAds
  class TargetingSpec

    MEN                = 1
    WOMEN              = 2
    GENDERS            = [MEN, WOMEN]
    ANDROID_OS         = 'Android'
    APPLE_OS           = 'iOS'
    OSES               = [ANDROID_OS, APPLE_OS]
    ANDROID_DEVICES    = %w(Android_Smartphone Android_Tablet)
    APPLE_DEVICES      = %w(iPhone iPad iPod)
    DEVICES            = ANDROID_DEVICES + APPLE_DEVICES
    INSTALLED          = 'installed'
    NOT_INSTALLED      = 'not_installed'
    APP_INSTALL_STATES = [INSTALLED, NOT_INSTALLED]

    attr_accessor :genders, :age_min, :age_max, :countries, :user_os, :user_device, :app_install_state

    def initialize
      # self.genders           = [WOMEN] # If nil, defaults to all genders.
      # self.age_min           = 18 # If nil, defaults to 18.
      # self.age_max           = 65 # If nil, defaults to 65+.
      self.countries         = ['US']
      # self.user_os           = [ANDROID_OS]
      # self.user_device       = ANDROID_DEVICES
      # self.app_install_state = NOT_INSTALLED
    end

    def validate!
      { gender: genders, countries: countries, user_os: user_os, user_device: user_device }.each_pair do |key, array|
        if array.present? && !array.is_a?(Array)
          raise Exception, "TargetingSpec: #{key} must be an array"
        end
      end

      { genders: [genders, GENDERS], user_os: [user_os, OSES], user_device: [user_device, DEVICES] }.each_pair do |key, provided_and_acceptable|
        provided, acceptable = provided_and_acceptable

        if provided.present? && (invalid = provided.detect { |value| !acceptable.include?(value) }).present?
          raise Exception, "TargetingSpec: #{bad} is an invalid #{key}"
        end
      end

      true
    end

    def to_hash
      {
        genders: genders,
        age_min: age_min,
        age_max: age_max,
        geo_locations: { countries: countries },
        user_os: user_os,
        user_device: user_device,
        app_install_state: app_install_state
      }.compact
    end

  end
end
