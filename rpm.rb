require 'sinatra'
require_relative 'lib/utils'
require_relative 'lib/rpm'
require_relative 'lib/data'

get '/' do
  flush
  init_data
  ":initialized"
end

get '/ads/:id' do
  content_type :json

  ad = Advert.find(params[:id].to_i)
  if ad.nil?
    raise AdvertNotFound, "No such advert: #{id}"
  else
    ad.to_h.to_json
  end
end

post '/match' do
  content_type :json

  req = JSON.parse(request.body.read, symbolize_names: true)
  begin
    main(req).to_json
  rescue CountryNotFound, ChannelNotFound => e
    "Invalid request"
  end
end
