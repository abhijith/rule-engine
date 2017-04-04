require_relative 'utils'

class RequestTest < Test::Unit::TestCase

  def setup
    @cat1  = Category.new("cars").save
    @ch1   = Channel.new(label: "car-example.com").save
    @ch1.categories = [@cat1]
    @india = Country.new(label: "india").save
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def test_initialize
    @r1 = Request.new(channel: "car-example.com", preferences: ["cars"], country: "india")
    assert_equal @ch1,    @r1.channel
    assert_equal @india,  @r1.country
    assert_equal [@cat1], @r1.preferences

    @r1 = Request.new(channel: "car-example.com", preferences: ["cars"], country: "india")
    assert_equal @ch1,    @r1.channel
    assert_equal @india,  @r1.country
    assert_equal [@cat1], @r1.preferences

    assert_raises ChannelNotFound do
      Request.new(channel: "unknown.com", preferences: ["cars"], country: "india")
    end

    assert_raises CountryNotFound do
      Request.new(channel: "car-example.com", preferences: ["cars"], country: "foo")
    end

    assert_equal [], Request.new(channel: "car-example.com", preferences: ["bike"], country: "india").preferences
  end

end
