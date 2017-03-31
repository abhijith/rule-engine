require_relative 'utils'

class ExprTest < Test::Unit::TestCase

  def setup
    @expr1   = Expr.new(field: :channel, type: :channel, value: 0, operator: :==)
    @expr2   = Expr.new(field: :categories, type: :category, value: [1], operator: :intersect?)

    @germany = Country.new(label: "germany").save
    @food    = Channel.new(label: "food-example.com").save
    @cars    = Category.new("cars").save
  end

  def test_satisfies?
    assert_equal true,  @expr1.satisfies?(Request.new(channel: "food-example.com", categories: ["cars"], country: "germany"), true)
  end

end

class ExprGroupTest < ExprTest

  def test_satisfies
    @expr3 = ExprGroup.new(:any?, [@expr1, @expr2])
    assert_equal true,  @expr3.satisfies?(Request.new(channel: "food-example.com", categories: ["cars"], country: "germany"), true)

    @expr3 = ExprGroup.new(:all?, [@expr1, @expr2])
    assert_equal false,  @expr3.satisfies?(Request.new(channel: "food-example.com", categories: ["cars"], country: "germany"), true)
  end

end
