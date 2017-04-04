require 'sinatra'
require_relative 'lib/utils'
require_relative 'lib/rpm'
require_relative 'lib/data'

get '/' do
  content_type :json
  status 200

  begin
    flush
    init_data
  rescue StandardError => e
    status 500
    e.message.to_json
  end

  true.to_json
end

get '/flush' do
  content_type :json
  status 200

  begin
    flush
  rescue StandardError => e
    status 500
    e.message.to_json
  end

  true.to_json
end

get '/ads/:id' do
  content_type :json

  begin
    ad = Advert.find(params[:id].to_i)
    if ad.nil?
      status 404
      nil.to_json
    else
      status 200
      return ad.to_h.to_json
    end
  rescue StandardError => e
    status 500
    e.message.to_json
  end
end

post '/match' do
  content_type :json

  req = JSON.parse(request.body.read, symbolize_names: true)
  begin
    status 200
    main(req).to_h.to_json
  rescue CountryNotFound, ChannelNotFound => e
    status 400
    e.message.to_json
  rescue StandardError => e
    status 500
    e.message.to_json
  end
end
