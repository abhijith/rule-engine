require_relative 'utils'

class ExprTest < Test::Unit::TestCase

  class Spurious ; end

  def setup
    @expr1 = Expr.new(field: :channel,     value: "car-example.com",                       operator: :==)
    @expr2 = Expr.new(field: :country,     value: "germany",                               operator: :==)
    @expr3 = Expr.new(field: :preferences, value: ["cars", "automobiles"],                 operator: :==)
    @expr4 = Expr.new(field: :preferences, value: ["automobiles"],                         operator: :intersect?)
    @expr5 = Expr.new(field: :channel,     value: ["car-example.com", "food-example.com"], operator: :member?)
    @expr6 = Expr.new(field: :country,     value: ["germany", "india"],                    operator: :member?)
    @expr7 = Expr.new(field: :preferences, value: "automobiles",                           operator: :parent_of?)

    @expr8 = ExprGroup.new(:all?, [
                             Expr.new(field: :channel,    value: "car-example.com", operator: :==),
                             Expr.new(field: :categories, value: "automobiles",     operator: :parent_of?)
                           ])


    @germany = Country.new(label: "germany").save
    @india   = Country.new(label: "india").save

    @car     = Channel.new(label: "car-example.com").save
    @food    = Channel.new(label: "food-example.com").save

    @c1 = Category.new("automobiles").save
    @c2 = Category.new("cars", 0).save
    @c3 = Category.new("bmw", 1).save

    @car.categories = [@c3]
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def test_satisfies?
    r = Request.new(channel: "car-example.com", preferences: ["cars", "automobiles"], country: "germany")
    assert_equal true, @expr1.satisfies?(r)
    assert_equal true, @expr2.satisfies?(r)
    assert_equal true, @expr3.satisfies?(r)
    assert_equal true, @expr4.satisfies?(r)

    r = Request.new(channel: "food-example.com", preferences: ["cars"], country: "germany")
    assert_equal true, @expr5.satisfies?(r)

    r = Request.new(channel: "car-example.com", preferences: ["cars"], country: "india")
    assert_equal true, @expr6.satisfies?(r)

    r = Request.new(channel: "car-example.com", preferences: ["automobiles"], country: "germany")
    assert_equal false, @expr7.satisfies?(r)

    r = Request.new(channel: "car-example.com", preferences: ["bmw"], country: "germany")
    assert_equal true, @expr7.satisfies?(r)

    r = Request.new(channel: "car-example.com", preferences: ["bmw"], country: "germany")
    assert_equal true, @expr8.satisfies?(r)

    assert_raises InvalidField do
      Expr.new(field: :cat, value: "automobiles", operator: :parent_of?).satisfies?(r)
    end

    assert_raises InvalidOperator do
      Expr.new(field: :categories, value: "automobiles", operator: :isa?).satisfies?(r)
    end

  end

end

class ExprGroupTest < ExprTest

  def test_satisfies?
    @expr6 = ExprGroup.new(:any?, [@expr1, @expr2])
    assert_equal true,  @expr6.satisfies?(Request.new(channel: "car-example.com", preferences: ["cars"], country: "germany"))

    @expr7 = ExprGroup.new(:all?, [@expr1, @expr2])
    assert_equal true,  @expr7.satisfies?(Request.new(channel: "car-example.com", preferences: ["cars"], country: "germany"))
  end

end
