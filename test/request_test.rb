require_relative 'utils'

class RequestTest < Test::Unit::TestCase

  def setup
    @cat1  = Category.new("cars").save
    @ch1   = Channel.new(label: "car-example.com").save
    @india = Country.new(label: "india").save
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def test_initialize
    @r1 = Request.new(channel: "car-example.com", categories: ["cars"], country: "india")
    assert_equal @ch1,    @r1.channel
    assert_equal @india,  @r1.country
    assert_equal [@cat1], @r1.categories

    assert_raises ChannelNotFound do
      Request.new(channel: "unknown.com", categories: ["cars"], country: "india")
    end

    assert_raises CountryNotFound do
      Request.new(channel: "car-example.com", categories: ["cars"], country: "foo")
    end

    assert_equal [], Request.new(channel: "car-example.com", categories: ["bike"], country: "india").categories
  end

end
