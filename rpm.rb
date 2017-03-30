require 'sinatra'

require_relative 'lib/utils'
require_relative 'lib/rpm'

get '/' do
  'Hello world!'
end

get '/ad/:id' do
  content_type :json
  Advert.find(params[:id].to_i)
  true.to_json
end

post '/match' do
  content_type :json
  r = JSON.parse(request.body.read, symbolize_names: true)
  main(r).to_json
end
