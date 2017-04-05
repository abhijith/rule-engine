ENV['RACK_ENV'] = 'test'

require_relative 'utils'
require_relative '../rpm'
require 'rack/test'

class HttpTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    init_data
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def app
    Sinatra::Application
  end

  def test_initialization
    get '/'
    assert last_response.ok?
    assert_equal "true", last_response.body
  end

  def test_flush
    get '/flush'
    assert last_response.ok?
    assert_equal "true", last_response.body
  end

  def test_ad
    get '/ads/0'
    assert last_response.ok?
    res = JSON.parse(last_response.body)
    assert_equal({ "label" => "volvo-s40" }, res)

    get '/ads/10'
    assert last_response.not_found?
    assert_equal "null", last_response.body
  end

  def assert_match(req, status, ad = nil)
    post '/match', req.to_json
    assert last_response.send(status)
    assert_equal(ad, JSON.parse(last_response.body)) if ad
  end

  def test_match
    assert_match({ channel: "car-example.com",  preferences: ["cars", "travel"], country: "germany" }, :client_error?)
    assert_match({  }, :client_error?)
    assert_match({ channel: "food-example.com", preferences: ["cars", "travel"], country: "india"   }, :client_error?)

    assert_match({channel: "team-bhp.com",     preferences: ["cars"], country: "sweden"  }, :ok?, { "label" => "volvo-s40"   })
    assert_match({channel: "team-bhp.com",     preferences: ["bmw"],  country: "germany" }, :ok?, { "label" => "bmw-i8"      })
    assert_match({channel: "trip-advisor.com", preferences: ["food"], country: "india"   }, :ok?, { "label" => "master-chef" })
    assert_match({channel: "trip-advisor.com", preferences: ["food"], country: "germany" }, :ok?, { "label" => "master-chef" })
    assert_match({channel: "trip-advisor.com", preferences: ["food"], country: "sweden"  }, :ok?, { "label" => "master-chef" })
    assert_match({channel: "trip-advisor.com", preferences: ["cars"], country: "sweden"  }, :ok?, { "label" => "air-berlin"  })
    assert_match({channel: "trip-advisor.com", preferences: ["cars"], country: "germany" }, :ok?, { "label" => "air-berlin"  })
    assert_match({channel: "trip-advisor.com", preferences: ["cars"], country: "india"   }, :ok?, {})
  end

end
