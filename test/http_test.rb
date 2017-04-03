ENV['RACK_ENV'] = 'test'

require_relative 'utils'
require_relative '../rpm'
require 'rack/test'

class RpmTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def setup
    @a1 = Advert.new(label: "nokia").save
    @a2 = Advert.new(label: "airbnb").save
  end

  def teardown
    get '/flush'
  end

  def app
    Sinatra::Application
  end

  def _test_initialization
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
    assert_equal({ "label" => "nokia" }, res)

    p last_response.methods.sort

    get '/ads/2'
    assert last_response.not_found?
    assert_equal "null", last_response.body
  end

  def test_match
    r1 = {
      channel: "car-example.com",
      categories: ["cars", "travel"],
      country: "germany"
    }

    r2 = {
      channel: "food-example.com",
      categories: ["cars", "travel"],
      country: "india"
    }

    post '/match', r1.to_json
    assert last_response.client_error?

    post '/match', r2.to_json
    assert last_response.client_error?
  end

end
