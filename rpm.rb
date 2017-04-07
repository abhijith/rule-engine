require 'sinatra'
require_relative 'lib/initializer'
require_relative 'lib/rpm'
require_relative 'lib/data'

def rescuing
  begin
    content_type :json
    status 200

    res = yield
  rescue StandardError => e
    status 500
    e.message.to_json
  end

  res.to_json
end

get '/' do
  rescuing do
    RpmLogger.info("Flushing data")
    flush
    RpmLogger.info("Initializing data")
    init_data
    RpmLogger.info("Initialized data")
    true
  end
end

get '/flush' do
  rescuing do
    RpmLogger.info("Flushing data")
    flush
    RpmLogger.info("Flushed data")
  end
end

get '/ads/:id' do
  rescuing do
    RpmLogger.info("Looking for ad: #{params[:id]}")
    ad = Advert.find(params[:id].to_i)

    if ad.nil?
      status 404
      RpmLogger.info("Did not find ad with id: #{params[:id]}")
      nil
    else
      RpmLogger.info("Found ad: #{ad.to_h}")
      status 200
      ad.to_h
    end
  end
end

post '/match' do
  rescuing do

    req = JSON.parse(request.body.read, symbolize_names: true)
    begin
      status 200
      RpmLogger.info("Got request to match: #{req}")
      res = main(req)
      RpmLogger.info("Response: #{res.to_h}")
      res.to_h
    rescue CountryNotFound, ChannelNotFound => e
      status 400
      RpmLogger.error(e.message)
      e.message
    end
  end
end
