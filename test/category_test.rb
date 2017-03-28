require_relative 'utils'

class CategoryTest < Test::Unit::TestCase

  def setup
    @a = Category.new(:a)
    @b = Category.new(:b)
    @c = Category.new(:c)
    @d = Category.new(:d)
    @e = Category.new(1)
    @f = Category.new(2)
  end

  def test_init
    assert_equal nil, Category.root
    Category.init
    assert_not_equal nil, Category.root
  end

  def test_parent
    @a.add_child(@b)
    assert_equal @a, @b.parent
    assert_equal @a.children, [@b]
  end

  def test_descendants
    assert_equal [], @a.descendants
    @a.add_child(@b)
    @a.add_child(@e)
    @e.add_child(@f)
    @b.add_child(@c)
    @c.add_child(@d)
    assert_equal [:b, :c, :d, 1, 2], @a.descendants.map(&:data)
  end

  def test_ancestors
    @a.add_child(@b)
    @b.add_child(@c)
    @c.add_child(@d)
    assert_equal [:c, :b, :a], @d.ancestors.map(&:data)
  end

end
