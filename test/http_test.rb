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

  def test_match
    r1 = {
      channel: "car-example.com",
      preferences: ["cars", "travel"],
      country: "germany"
    }

    r2 = {
      channel: "food-example.com",
      preferences: ["cars", "travel"],
      country: "india"
    }

    post '/match', r1.to_json
    assert last_response.client_error?

    post '/match', r2.to_json
    assert last_response.client_error?

    post '/match', ({channel: "team-bhp.com", preferences: ["cars"], country: "sweden"}).to_json
    assert last_response.ok?
    assert_equal({ "label" => "volvo-s40" }, JSON.parse(last_response.body))

    post '/match', ({channel: "team-bhp.com", preferences: ["bmw"], country: "germany"}).to_json
    assert last_response.ok?
    assert_equal({ "label" => "bmw-i8" }, JSON.parse(last_response.body))

    post '/match', ({channel: "trip-advisor.com", preferences: ["food"], country: "india"}).to_json
    assert last_response.ok?
    assert_equal({ "label" => "master-chef" }, JSON.parse(last_response.body))

    post '/match', ({channel: "trip-advisor.com", preferences: ["food"], country: "germany"}).to_json
    assert last_response.ok?
    assert_equal({ "label" => "master-chef" }, JSON.parse(last_response.body))

    post '/match', ({channel: "trip-advisor.com", preferences: ["food"], country: "sweden"}).to_json
    assert last_response.ok?
    assert_equal({ "label" => "master-chef" }, JSON.parse(last_response.body))

    post '/match', ({channel: "trip-advisor.com", preferences: ["cars"], country: "sweden"}).to_json
    assert last_response.ok?
    assert_equal({ "label" => "air-berlin" }, JSON.parse(last_response.body))

    post '/match', ({channel: "trip-advisor.com", preferences: ["cars"], country: "germany"}).to_json
    assert last_response.ok?
    assert_equal({ "label" => "air-berlin" }, JSON.parse(last_response.body))

    post '/match', ({channel: "trip-advisor.com", preferences: ["cars"], country: "india"}).to_json
    assert last_response.ok?
    assert_equal({}, JSON.parse(last_response.body))
  end

end
