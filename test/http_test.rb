require_relative 'utils'

class HttpTest < Test::Unit::TestCase

  def setup
    @cars   = Category.new("cars").save
    @car_ex = Channel.new(label: "car-example.com").save

    @r1 = Request.new(channel: "cars-example.com", categories: [@cars])
    @r1 = Request.new(channel: "fake.com", categories: [@cars])
  end

  def teardown
    [Channel, Country, Category, Advert].each(&:destroy_all)
  end

  def test_all
  end

end
