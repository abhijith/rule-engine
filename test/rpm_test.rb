require_relative 'utils'

class RpmTest < Test::Unit::TestCase

  def setup
    @ad1 = Advert.new(label: "bmw-m3").save
    @ad1.start_date = DateTime.now - 1000
    @ad1.end_date   = DateTime.now + 1000

    @ad2 = Advert.new(label: "airbnb").save

    @cars    = Category.new("cars")
    @bmw     = Category.new("bmw")
    @audi    = Category.new("audi")
    @food    = Category.new("food")
    @south   = Category.new("south-indian")
    @north   = Category.new("north-indian")

    @india   = Country.new(label: "india").save
    @germany = Country.new(label: "germany").save

    [@cars, @bmw, @food, @audi, @south, @north].map(&:save)

    @cars.add_child(@bmw)
    @cars.add_child(@audi)

    @food.add_child(@south)
    @food.add_child(@north)

    @car_ex  = Channel.new(label: "car-example.com").save
    @food_ex = Channel.new(label: "food-example.com").save

    @car_ex.categories = [@cars, @food]

    @expr1 = Expr.new(field: :channel,    type: Channel,  value: 0, operator: :==)
    @expr2 = Expr.new(field: :country,    type: Country,  value: 0, operator: :==)
    @expr3 = Expr.new(field: :categories, type: Category, value: [0, 1], operator: :intersect?)

    @expr4  = ExprGroup.new(:any?, [@expr1, @expr2, @expr3])

    @ad1.constraints = @expr4

    @l1 = Limit.new(@germany, 2)
    @l2 = Limit.new(@food_ex, 2)
    @ad1.limits = [@l1, @l2]
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def _test_all
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

    assert_equal true,  @ad1.live?
    assert_equal false, @ad1.expired?
    assert_equal 1, Advert.live.count
    assert_equal 1, Advert.expired.count

    assert_equal false, @ad1.exhausted?
    assert_equal @l1, @ad1.fetch_limit(@germany)
    assert_equal [@l1, @l2], @ad1.fetch_limits([@germany, @food_ex])
    assert_equal false, @ad1.limits_exceeded?([@germany, @food_ex])

    assert_equal true, @ad1.constraints.satisfies?(Request.new(r1))
    @expr5  = ExprGroup.new(:all?, [@expr1, @expr2, @expr3])
    @ad1.constraints = @expr5
    assert_equal false, @ad1.constraints.satisfies?(Request.new(r2))
  end

  def test_main
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

    assert_equal @ad1, main(r1)
    @expr5  = ExprGroup.new(:all?, [@expr1, @expr2, @expr3])
    @ad1.constraints = @expr5

    assert_equal nil, main(r2)
  end

end
