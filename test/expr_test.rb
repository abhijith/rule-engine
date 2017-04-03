require_relative 'utils'

class ExprTest < Test::Unit::TestCase

  class Cat ; end

  # request.attr.is_a?
  def setup
    @expr1 = Expr.new(field: :channel, type: Channel, value: 0, operator: :==)
    @expr2 = Expr.new(field: :country, type: Country, value: 0, operator: :==)
    @expr3 = Expr.new(field: :categories, type: Category, value: [1, 0], operator: :==)
    @expr4 = Expr.new(field: :categories, type: Category, value: [0], operator: :intersect?)
    @expr5 = Expr.new(field: :categories, type: Category, value: 0, operator: :subtype_of?)

    @germany = Country.new(label: "germany").save
    @car     = Channel.new(label: "car-example.com").save

    @c1 = Category.new("automobiles").save
    @c2 = Category.new("cars", 0).save
    @c3 = Category.new("bmw", 1).save
  end

  def test_satisfies?
    r1 = Request.new(channel: "car-example.com", categories: ["cars", "automobiles"], country: "germany")
    assert_equal true, @expr1.satisfies?(r1)
    assert_equal true, @expr2.satisfies?(r1)
    assert_equal true, @expr3.satisfies?(r1)
    assert_equal true, @expr4.satisfies?(r1)

    r2 = Request.new(channel: "car-example.com", categories: ["cars"], country: "germany")
    assert_equal true, @expr5.satisfies?(r2)

    r3 = Request.new(channel: "car-example.com", categories: ["automobiles"], country: "germany")
    assert_equal false, @expr5.satisfies?(r3)

    assert_raises Invalid do
      assert_equal false, Expr.new(field: :categories, type: Cat, value: 0, operator: :subtype_of?).satisfies?(r3)
    end

    assert_raises Invalid do
      assert_equal false, Expr.new(field: :categories, type: Category, value: 0, operator: :isa?).satisfies?(r3)
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
