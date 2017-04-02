require_relative 'utils'

class ExprTest < Test::Unit::TestCase

  def setup
    @expr1   = Expr.new(field: :channel, type: :channel, value: 0, operator: :==)
    @expr2   = Expr.new(field: :categories, type: :category, value: [1], operator: :intersect?)

    @germany = Country.new(label: "germany").save
    @car     = Channel.new(label: "car-example.com").save

    @c1    = Category.new("automobiles").save
    @c2    = Category.new("cars", 0).save
    @c3    = Category.new("bmw", 1).save

    @expr3 = Expr.new(field: :categories, type: :categories, value: [0], operator: :isa?)
  end

  def test_satisfies?
    assert_equal true, @expr1.satisfies?(Request.new(channel: "car-example.com", categories: ["cars"], country: "germany"))
    pp @expr3.to_h
    assert_equal true, @expr3.satisfies?(Request.new(channel: "car-example.com", categories: ["bmw"], country: "germany"))
  end

end

class ExprGroupTest < ExprTest

  def _test_satisfies
    @expr3 = ExprGroup.new(:any?, [@expr1, @expr2])
    assert_equal true,  @expr3.satisfies?(Request.new(channel: "car-example.com", categories: ["cars"], country: "germany"))

    @expr3 = ExprGroup.new(:all?, [@expr1, @expr2])
    assert_equal false,  @expr3.satisfies?(Request.new(channel: "car-example.com", categories: ["cars"], country: "germany"))
  end

end
