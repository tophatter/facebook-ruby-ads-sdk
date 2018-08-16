# frozen_string_literal: true

require 'spec_helper'

describe FacebookAds::AdTargeting do
  let(:targeting) { FacebookAds::AdTargeting.new }

  describe '#geo_locations' do
    let(:custom_locations) { [{ radius: 10, distance_unit: 'mile', address_string: '1601 Willow Road, Menlo Park, CA 94025' }] }
    let(:countries) { ['JP'] }

    it 'should return custom locations if specified' do
      targeting.custom_locations = custom_locations
      expect(targeting.geo_locations).to eq(custom_locations: custom_locations)
    end

    it 'should return countries if specified' do
      targeting.countries = countries
      expect(targeting.geo_locations).to eq(countries: countries)
    end

    it 'should default to US if nothing is specified' do
      expect(targeting.geo_locations).to eq(countries: ['US'])
    end
  end
end
