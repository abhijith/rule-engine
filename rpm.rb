require 'sinatra'
require_relative 'lib/utils'
require_relative 'lib/rpm'
require_relative 'lib/data'

get '/' do
  status 200
  flush
  init_data
  ":initialized"
end

get '/ads/:id' do
  content_type :json
  status 200
  ad = Advert.find(params[:id].to_i)
  raise AdvertNotFound, "No such advert: #{id}" if ad.nil?

  ad.to_h.to_json
end

post '/match' do
  status 200
  content_type :json
  r = JSON.parse(request.body.read, symbolize_names: true)
  main(r).to_json
end
