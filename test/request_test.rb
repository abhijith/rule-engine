require_relative 'utils'

class RequestTest < Test::Unit::TestCase

  def setup
    @cat1 = Category.new("cars").save
    @ch1  = Channel.new(label: "car-example.com").save
    @india = Country.new(label: "india").save
  end

  def teardown
    [Channel, Country, Category, Advert].each(&:destroy_all)
  end

  def test_initialize
    @r1 = Request.new(channel: @ch1.label, categories: [@cat1.label], country: "india")

    assert_equal @ch1,  @r1.channel
    assert_equal @india, @r1.country
    assert_equal [@cat1], @r1.categories

    @r2 = Request.new(channel: "unknown.com", categories: ["bike"], country: "foo")
    assert_equal nil, @r2.channel
    assert_equal nil, @r2.country
    assert_equal [],  @r2.categories
  end

end
