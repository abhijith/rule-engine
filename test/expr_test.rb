require_relative 'utils'

class ExprTest < Test::Unit::TestCase

  # request.attr.is_a?
  def setup
    @expr1 = Expr.new(field: :channel, type: :channel, value: 0, operator: :==)
    @expr2 = Expr.new(field: :country, type: :country, value: 0, operator: :==)
    @expr3 = Expr.new(field: :categories, type: :category, value: [1, 0], operator: :==)
    @expr4 = Expr.new(field: :categories, type: :category, value: [0], operator: :&)
    @expr5 = Expr.new(field: :categories, type: :category, value: 0, operator: :isa?)

    @germany = Country.new(label: "germany").save
    @car     = Channel.new(label: "car-example.com").save

    @c1    = Category.new("automobiles").save
    @c2    = Category.new("cars", 0).save
    @c3    = Category.new("bmw", 1).save
  end

  def test_satisfies?
    r1 = Request.new(channel: "car-example.com", categories: ["cars", "automobiles"], country: "germany")
    assert_equal true, @expr1.satisfies?(r1, true)
    assert_equal true, @expr2.satisfies?(r1, true)
    assert_equal true, @expr3.satisfies?(r1, true)
    assert_equal true, @expr4.satisfies?(r1, true)


    # r2 = Request.new(categories: ["cars", "automobiles"])
    # assert_equal true, @expr3.satisfies?(r1, true)


  end

end

class ExprGroupTest < ExprTest

  def test_satisfies
    @expr6 = ExprGroup.new(:any?, [@expr1, @expr2])
    assert_equal true,  @expr6.satisfies?(Request.new(channel: "car-example.com", categories: ["cars"], country: "germany"))

    @expr7 = ExprGroup.new(:all?, [@expr1, @expr2])
    assert_equal true,  @expr7.satisfies?(Request.new(channel: "car-example.com", categories: ["cars"], country: "germany"))
  end

end
