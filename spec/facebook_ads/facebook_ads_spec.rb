# frozen_string_literal: true

require 'spec_helper'

# rspec spec/facebook_ads/facebook_ads_spec.rb
describe FacebookAds do
  describe '#base_uri' do
    subject { FacebookAds.base_uri }

    context 'when the version is not overridden' do
      it { is_expected.to eq('https://graph.facebook.com/v2.9') }
    end

    context 'when the version is overridden' do
      before { FacebookAds.api_version = '2.10' }
      after { FacebookAds.api_version = '2.9' }

      it { is_expected.to eq('https://graph.facebook.com/v2.10') }
    end
  end

  describe '#api_version' do
    subject { FacebookAds.api_version }

    context 'when the version is not overridden' do
      it { is_expected.to eq('2.9') }
    end

    context 'when the version is overridden' do
      before { FacebookAds.api_version = '2.10' }
      after { FacebookAds.api_version = '2.9' }

      it { is_expected.to eq('2.10') }
    end
  end

  describe '#stubbornly' do
    subject { FacebookAds.stubbornly { true } }

    it { is_expected.to eq(true) }
  end

  describe '#stubbornly_get', :vcr do
    subject(:response) { FacebookAds.stubbornly_get('http://worldtimeapi.org/api/ip') }

    let(:parsed_response) { JSON.parse(response) }

    it 'executes the request for the provided url' do
      expect(parsed_response).to eq(
        'abbreviation' => 'AKDT',
        'client_ip' => '66.58.139.118',
        'datetime' => '2020-09-29T11:59:09.743279-08:00',
        'day_of_week' => 2,
        'day_of_year' => 273,
        'dst' => true,
        'dst_from' => '2020-03-08T11:00:00+00:00',
        'dst_offset' => 3600,
        'dst_until' => '2020-11-01T10:00:00+00:00',
        'raw_offset' => -32_400,
        'timezone' => 'America/Anchorage',
        'unixtime' => 1_601_409_549,
        'utc_datetime' => '2020-09-29T19:59:09.743279+00:00',
        'utc_offset' => '-08:00',
        'week_number' => 40
      )
    end
  end
end
