require_relative 'utils'

class ExprTest < Test::Unit::TestCase

  def setup
    @expr1 = Expr.new(field: :channel, type: :channel, value: 1, operator: :==)
    @expr2 = Expr.new(field: :channel, type: :channel, value: 1, operator: :==)
  end

  def test_satisfies?
    assert_equal true,  @expr1.satisfies?(Request.new(channel: 1))
    assert_equal false, @expr1.satisfies?(Request.new(channel: 2))

    @expr3 = ExprGroup.new(:any?, [@expr1, @expr2])
    @expr4 = ExprGroup.new(:all?, [@expr1, @expr2])

    assert_equal true, @expr3.satisfies?(Request.new(channel: 1))
    assert_equal false, @expr3.satisfies?(Request.new(channel: 2))
  end

end

class ExprGroupTest < Test::Unit::TestCase

  def setup
  end

end
