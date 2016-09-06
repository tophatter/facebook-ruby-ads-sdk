# spec/support/fake_facebook.rb
require 'sinatra/base'

class RackFacebook < Sinatra::Base

  get '/v2.6/me/adaccounts' do
    json_response 200, 'adaccounts.json'
  end

  get '/v2.6/act_861827983860489' do
    json_response 200, 'act_861827983860489.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end

end
