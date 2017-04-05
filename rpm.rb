require 'sinatra'
require_relative 'lib/utils'
require_relative 'lib/rpm'
require_relative 'lib/data'

def rescuing
  begin
    yield
  rescue StandardError => e
    status 500
    e.message.to_json
  end
  true.to_json
end

get '/' do
  content_type :json
  status 200

  begin
    RpmLogger.info("Flushing data")
    flush
    RpmLogger.info("Initializing data")
    init_data
    RpmLogger.info("Initialized data")
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
    RpmLogger.info("Flushing data")
    flush
    RpmLogger.info("Flushed data")
  rescue StandardError => e
    status 500
    e.message.to_json
  end

  true.to_json
end

get '/ads/:id' do
  content_type :json

  begin
    RpmLogger.info("Looking for ad: #{params[:id]}")
    ad = Advert.find(params[:id].to_i)

    if ad.nil?
      RpmLogger.info("Did not find ad with id: #{params[:id]}")

      status 404
      nil.to_json
    else
      RpmLogger.info("Found ad: #{ad.to_h}")
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
    RpmLogger.info("Got request to match: #{req}")
    res = main(req)
    RpmLogger.info("Response: #{res.to_h}")
    res.to_h.to_json
  rescue CountryNotFound, ChannelNotFound => e
    status 400
    RpmLogger.error(e.message)
    p e.methods.sort
    e.message.to_json
  rescue StandardError => e
    RpmLogger.unknown(e.message)
    status 500
    e.message.to_json
  end
end
