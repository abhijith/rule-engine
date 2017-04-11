require_relative 'initializer'

class ExprTest < Test::Unit::TestCase

  class Spurious ; end

  def setup
    @expr1 = Expr.==(:channel, "car-example.com")
    @expr2 = Expr.==(:country, "germany")
    @expr3 = Expr.==(:preferences, ["cars", "automobiles"])
    @expr4 = Expr.intersect?(:preferences, ["automobiles"])
    @expr5 = Expr.member?(:channel, ["car-example.com", "food-example.com"])
    @expr6 = Expr.member?(:country, ["germany", "india"])
    @expr7 = Expr.parent_of?(:preferences, "automobiles")

    @expr8 = ExprGroup.all?([Expr.==(:channel, "car-example.com"),
                             Expr.parent_of?(:categories, "automobiles")])


    @germany = Country.new(label: "germany").save
    @india   = Country.new(label: "india").save

    @car     = Channel.new(label: "car-example.com").save
    @food    = Channel.new(label: "food-example.com").save

    @c1 = Category.new(label: "automobiles").save
    @c2 = Category.new(label: "cars", parent_id: 0).save
    @c3 = Category.new(label: "bmw", parent_id: 1).save

    @car.categories = [@c3]
  end

  def teardown
    [Channel, Country, Category, Advert, Limit].each(&:destroy_all)
  end

  def test_satisfied?
    r = Request.new(channel: "car-example.com", preferences: ["cars", "automobiles"], country: "germany")
    assert_equal true, @expr1.satisfied?(r)
    assert_equal true, @expr2.satisfied?(r)
    assert_equal true, @expr3.satisfied?(r)
    assert_equal true, @expr4.satisfied?(r)

    r = Request.new(channel: "food-example.com", preferences: ["cars"], country: "germany")
    assert_equal true, @expr5.satisfied?(r)

    r = Request.new(channel: "car-example.com", preferences: ["cars"], country: "india")
    assert_equal true, @expr6.satisfied?(r)

    r = Request.new(channel: "car-example.com", preferences: ["automobiles"], country: "germany")
    assert_equal false, @expr7.satisfied?(r)

    r = Request.new(channel: "car-example.com", preferences: ["bmw"], country: "germany")
    assert_equal true, @expr7.satisfied?(r)

    r = Request.new(channel: "car-example.com", preferences: ["bmw"], country: "germany")
    assert_equal true, @expr8.satisfied?(r)

    assert_raises InvalidField do
      Expr.parent_of?(:cat, "automobiles").satisfied?(r)
    end

    assert_raises InvalidOperator do
      Expr.isa?(:categories, "automobiles").satisfied?(r)
    end

  end

end

class ExprGroupTest < ExprTest

  def test_satisfied?
    @expr6 = ExprGroup.any?([@expr1, @expr2])
    assert_equal true,  @expr6.satisfied?(Request.new(channel: "car-example.com", preferences: ["cars"], country: "germany"))

    @expr7 = ExprGroup.all?([@expr1, @expr2])
    assert_equal true,  @expr7.satisfied?(Request.new(channel: "car-example.com", preferences: ["cars"], country: "germany"))
  end

end
