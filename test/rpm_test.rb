require_relative 'utils'

class RpmTest < Test::Unit::TestCase

  def setup
    @expr1 = Expr.new(ch: :category, ad: :category, op: :==)
    @expr2 = Expr.new(ch: :pref, ad: :category, op: :intersect?)
    @expr3 = Expr.new(ch: :language, ad: :language, op: :==)
    @expr4 = ExprGroup.new(:any?, [@expr1, @expr2])
    @expr5 = ExprGroup.new(:all?, [@expr1, @expr4])

    @a1 = Advert.new(cat: ["cars"])
    @a1.language = "english"
    @a1.save

    @a2 = Advert.new(cat: ["gadgets"])
    @a2.language = "german"
    @a2.save

    @a3 = Advert.new(cat: ["cooking"])
    @a3.language = "german"
    @a3.save

    @c1 = Channel.new(cat: ["cars"], preference: ["cars", "gadgets"])
    @c1.language = "english"

    @c2 = Channel.new(cat: ["cooking"], preference: ["food"])
    @c2.language = "german"
  end

  def teardown
    Advert.destroy_all
  end

  def test_all
    assert_equal true,   @expr1.run(@c1, @a1)
    assert_equal true,   @expr2.run(@c1, @a1)
    assert_equal true,   @expr3.run(@c1, @a1)
    assert_equal true,   @expr4.run(@c1, @a1)
    assert_equal true,   @expr5.run(@c1, @a1)

    assert_equal false,  @expr1.run(@c2, @a1)
    assert_equal false,  @expr2.run(@c2, @a1)
    assert_equal false,  @expr3.run(@c2, @a1)
    assert_equal false,  @expr4.run(@c2, @a1)
    assert_equal false,  @expr5.run(@c2, @a1)

    assert_equal false,  @expr1.run(@c1, @a2)
    assert_equal true,   @expr2.run(@c1, @a2)
    assert_equal false,  @expr3.run(@c1, @a2)
    assert_equal true,   @expr4.run(@c1, @a2)
    assert_equal false,  @expr5.run(@c1, @a2)

    assert_equal false,  @expr1.run(@c2, @a2)
    assert_equal false,  @expr2.run(@c2, @a2)
    assert_equal true,   @expr3.run(@c2, @a2)
    assert_equal false,  @expr4.run(@c2, @a2)
    assert_equal false,  @expr5.run(@c2, @a2)
  end

end
