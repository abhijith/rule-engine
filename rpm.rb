require 'sinatra'

require_relative 'lib/utils'
require_relative 'lib/rpm'

get '/' do
  'Hello world!'
end

get '/ad/:id' do
  Advert.find(params[:id].to_i)
end

post '/match' do
  r = JSON.parse(request.body.read, symbolize_names: true)
  main(r)
end
