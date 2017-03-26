require_relative 'utils'

class RpmTest < Test::Unit::TestCase

  def setup
    @expr1 = Expr.new(channel: :category, ad: :category, op: :==)
    @expr2 = Expr.new(channel: :preferences, ad: :category, op: :intersect?)
    @expr3 = Expr.new(channel: :language, ad: :language, op: :==)
    @expr4 = ExprGroup.new(:any?, [@expr1, @expr2])
    @expr5 = ExprGroup.new(:all?, [@expr1, @expr4])
    @expr6 = ExprGroup.new(:any?, [@expr1, @expr4])

    @a1 = Advert.new(category: ["cars"])
    @a1.language = "english"
    @a1.save

    @a2 = Advert.new(category: ["gadgets"])
    @a2.language = "german"
    @a2.save

    @a3 = Advert.new(category: ["cooking"])
    @a3.language = "german"
    @a3.save

    @c1 = Channel.new(category: ["cars"], preferences: ["cars", "gadgets"])
    @c1.language = "english"

    @c2 = Channel.new(category: ["cooking"], preferences: ["food"])
    @c2.language = "german"
  end

  def teardown
    Advert.destroy_all
  end

  def test_all
    assert_equal true,  @expr1.run(@c1, @a1)
    assert_equal true,  @expr2.run(@c1, @a1)
    assert_equal true,  @expr3.run(@c1, @a1)
    assert_equal true,  @expr4.run(@c1, @a1)
    assert_equal true,  @expr5.run(@c1, @a1)
    assert_equal true,  @expr6.run(@c1, @a1)

    assert_equal false, @expr1.run(@c2, @a1)
    assert_equal false, @expr2.run(@c2, @a1)
    assert_equal false, @expr3.run(@c2, @a1)
    assert_equal false, @expr4.run(@c2, @a1)
    assert_equal false, @expr5.run(@c2, @a1)
    assert_equal true,  @expr6.run(@c1, @a1)

    assert_equal false, @expr1.run(@c1, @a2)
    assert_equal true,  @expr2.run(@c1, @a2)
    assert_equal false, @expr3.run(@c1, @a2)
    assert_equal true,  @expr4.run(@c1, @a2)
    assert_equal false, @expr5.run(@c1, @a2)
    assert_equal true,  @expr6.run(@c1, @a1)

    assert_equal false, @expr1.run(@c2, @a2)
    assert_equal false, @expr2.run(@c2, @a2)
    assert_equal true,  @expr3.run(@c2, @a2)
    assert_equal false, @expr4.run(@c2, @a2)
    assert_equal false, @expr5.run(@c2, @a2)
    assert_equal true,  @expr6.run(@c1, @a1)
  end

end
