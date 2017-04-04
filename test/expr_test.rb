require_relative 'utils'

class ExprTest < Test::Unit::TestCase

  class Spurious ; end

  def setup
    @expr1 = Expr.new(field: :channel,    type: Channel,  value: 0,      operator: :==)
    @expr2 = Expr.new(field: :country,    type: Country,  value: 0,      operator: :==)
    @expr3 = Expr.new(field: :categories, type: Category, value: [1, 0], operator: :==)
    @expr4 = Expr.new(field: :categories, type: Category, value: [0],    operator: :intersect?)
    @expr5 = Expr.new(field: :channel,    type: Channel,  value: [0, 1], operator: :member?)
    @expr6 = Expr.new(field: :country,    type: Country,  value: [0, 1], operator: :member?)
    @expr7 = Expr.new(field: :categories, type: Category, value: 0,      operator: :parent_of?)

    @expr8 = ExprGroup.new(:all?, [
                             Expr.new(field: :channel,     type: Channel,  value: 0, operator: :==),
                             Expr.new(field: :preferences, type: Category, value: 0, operator: :parent_of?)
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
    r = Request.new(channel: "car-example.com", categories: ["cars", "automobiles"], country: "germany")
    assert_equal true, @expr1.satisfies?(r)
    assert_equal true, @expr2.satisfies?(r)
    assert_equal true, @expr3.satisfies?(r)
    assert_equal true, @expr4.satisfies?(r)

    r = Request.new(channel: "food-example.com", categories: ["cars"], country: "germany")
    assert_equal true, @expr5.satisfies?(r)

    r = Request.new(channel: "car-example.com", categories: ["cars"], country: "india")
    assert_equal true, @expr6.satisfies?(r)

    r = Request.new(channel: "car-example.com", categories: ["automobiles"], country: "germany")
    assert_equal false, @expr7.satisfies?(r)

    r = Request.new(channel: "car-example.com", categories: ["bmw"], country: "germany")
    assert_equal true, @expr7.satisfies?(r)

    r = Request.new(channel: "car-example.com", categories: ["bmw"], country: "germany")
    assert_equal true, @expr8.satisfies?(r)

    assert_raises InvalidType do
      Expr.new(field: :categories, type: Spurious, value: 0, operator: :parent_of?).satisfies?(r)
    end

    assert_raises InvalidType do
      Expr.new(field: :categories, type: Spurious, value: [1, 0], operator: :==).satisfies?(r)
    end

    assert_raises InvalidOperator do
      Expr.new(field: :categories, type: Category, value: 0, operator: :isa?).satisfies?(r)
    end

    assert_raises InvalidField do
      Expr.new(field: :category, type: Category, value: 0, operator: :==).satisfies?(r)
    end

  end

end

class ExprGroupTest < ExprTest

  def test_satisfies?
    @expr6 = ExprGroup.new(:any?, [@expr1, @expr2])
    assert_equal true,  @expr6.satisfies?(Request.new(channel: "car-example.com", categories: ["cars"], country: "germany"))

    @expr7 = ExprGroup.new(:all?, [@expr1, @expr2])
    assert_equal true,  @expr7.satisfies?(Request.new(channel: "car-example.com", categories: ["cars"], country: "germany"))
  end

end
