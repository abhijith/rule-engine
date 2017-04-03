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
  raise Invalid, "no such advert: #{id}" if a.nil?

  ad.to_h.to_json
end

post '/match' do
  content_type :json
  r = JSON.parse(request.body.read, symbolize_names: true)
  main(r).to_json
end
