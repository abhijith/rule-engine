require_relative 'utils'

class CategoryTest < Test::Unit::TestCase

  def setup
    @a = Category.new(:cars)
    @b = Category.new(:bmw)
    @c = Category.new(:audi)
    @d = Category.new(:cuisine)
    @e = Category.new(:chinese)
    @f = Category.new(:indian)
  end

  def test_id
    @a.save
    @b.save
    assert_equal 0, @a.id
    assert_equal 1, @b.id
  end

  def test_parent
    @a.save
    @b.save
    @c.save

    @a.add_child(@b)
    @a.add_child(@c)
    assert_equal @a, @b.parent
    assert_equal @a.children, [@b, @c]
  end

  # def test_descendants
  #   assert_equal [], @a.descendants
  #   @a.add_child(@b)
  #   @a.add_child(@e)
  #   @e.add_child(@f)
  #   @b.add_child(@c)
  #   @c.add_child(@d)
  #   assert_equal [:b, :c, :d, 1, 2], @a.descendants.map(&:label)
  # end

  # def test_ancestors
  #   @a.add_child(@b)
  #   @b.add_child(@c)
  #   @c.add_child(@d)
  #   assert_equal [:c, :b, :a], @d.ancestors.map(&:label)
  # end

  # def test_find
  #   @a.save
  #   @b.save
  #   assert_equal @a2, Category.find(0)
  #   assert_equal @a1, Category.find(1)
  #   assert_equal nil, Category.find(2)
  # end

end
