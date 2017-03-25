require_relative 'utils'

class TreeTest < Test::Unit::TestCase

  def setup
    @a = TreeNode.new(:a)
    @b = TreeNode.new(:b)
    @c = TreeNode.new(:c)
    @d = TreeNode.new(:d)
    @e = TreeNode.new(1)
    @f = TreeNode.new(2)
  end

  def test_parent
    @a << @b
    assert_equal @a, @b.parent
    assert_equal @a.children, [@b]
  end

  def test_descendants
    assert_equal [], @a.descendants
    @a << @b
    @a << @e
    @e << @f
    @b << @c
    @c << @d
    assert_equal [:b, :c, :d, 1, 2], @a.descendants.map(&:data)
  end

  def test_ancestors
    @a << @b
    @b << @c
    @c << @d
    assert_equal [:c, :b, :a], @d.ancestors.map(&:data)
  end

end
