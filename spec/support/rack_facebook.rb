# spec/support/fake_facebook.rb
require 'sinatra/base'

class RackFacebook < Sinatra::Base

  get '/v2.6/me/adaccounts' do
    json_response 200, 'adaccounts.json'
  end

  get '/v2.6/act_861827983860489' do
    json_response 200, 'act_861827983860489.json'
  end

  get '/v2.6/act_861827983860489/campaigns' do
    json_response 200, 'campaigns.json'
  end

  get '/v2.6/act_861827983860489/adimages' do
    json_response 200, 'adimages.json'
  end

  get '/v2.6/act_861827983860489/adcreatives' do
    json_response 200, 'adcreatives.json'
  end

  get '/v2.6/act_861827983860489/adsets' do
    json_response 200, 'adsets.json'
  end

  get '/v2.6/act_861827983860489/ads' do
    json_response 200, 'ads.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    filename = File.dirname(__FILE__) + '/fixtures/' + file_name
    File.open(filename, 'rb').read
  end

end
