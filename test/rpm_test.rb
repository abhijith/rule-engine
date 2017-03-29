require_relative 'utils'

class RpmTest < Test::Unit::TestCase

  def setup
    @ad1     = Advert.new(label: "bmw-m3").save
    @ad2     = Advert.new(label: "master-chef").save

    cars    = Category.new("cars")
    bmw     = Category.new("bmw")
    audi    = Category.new("audi")
    food    = Category.new("food")
    south   = Category.new("south-indian")
    north   = Category.new("north-indian")

    india   = Country.new(label: "india").save
    germany = Country.new(label: "germany").save

    [cars, bmw, food, audi, south, north].map(&:save)

    cars.add_child(bmw)
    cars.add_child(audi)

    food.add_child(south)
    food.add_child(north)

    car_channel  = Channel.new(label: "car-example.com").save
    food_channel = Channel.new(label: "food-example.com").save

    car_channel.categories  = [cars]
    food_channel.categories = [food]

    expr1 = Expr.new(field: :channel,    type: :channel,  value: 0, operator: :==)
    expr2 = Expr.new(field: :country,    type: :country,  value: [0, 1], operator: :member?)
    expr3 = Expr.new(field: :categories, type: :category, value: [0, 1], operator: :intersect?)
    expr4 = Expr.new(field: :categories, type: :category, value: [0], operator: :descendant?)

    expr  = ExprGroup.new(:all?, [expr1, expr2, expr3])

    @ad1.constraints = expr
    @ad2.constraints = expr4
  end

  def teardown
    Advert.destroy_all
    Channel.destroy_all
    Country.destroy_all
  end

  def test_all
    r1 = {
      channel: "car-example.com",
      categories: ["cars"],
      country: "germany"
    }

    r2 = {
      channel: "food-example.com",
      categories: ["cars", "travel"],
      country: "india"
    }

    assert_equal true,  @ad1.constraints.satisfies?(Request.new(r1))
    assert_equal false, @ad1.constraints.satisfies?(Request.new(r2))
  end

end

class Array
  def intersect?(x)
    not (self & x).empty?
  end
end
