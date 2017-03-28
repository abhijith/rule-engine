require_relative 'utils'

class ExprTest < Test::Unit::TestCase
  def setup
    @expr1 = Expr.new(field: :channel, type: :channel, value: 1, operator: :==)
  end

  def test_satisfies?
    assert_equal true,  @expr1.satisfies?(Request.new(channel: 1))
    assert_equal false, @expr1.satisfies?(Request.new(channel: 2))
  end

  def teardown
  end
end

class ExprGroupTest < Test::Unit::TestCase
  def setup
  end

  def teardown
  end
end
