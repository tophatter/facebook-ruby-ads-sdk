require 'sinatra/base'

class RackFacebook < Sinatra::Base

  get '/v2.6/:object_id' do
    json_response 200, "#{params['object_id']}.json"
  end

  get '/v2.6/:object_id/:edge' do
    json_response 200, "#{params['object_id']}/#{params['edge']}.json"
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    filename = File.dirname(__FILE__) + '/fixtures/' + file_name
    File.open(filename, 'rb').read
  end

end
