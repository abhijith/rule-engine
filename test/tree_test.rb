require_relative 'utils'

class TreeTest < Test::Unit::TestCase

  def setup
    a = TreeNode.new(:a)
    b = TreeNode.new(:b)
    c = TreeNode.new(:c)
    d = TreeNode.new(:d)
    [a, b, c, d].reduce {|acc, x| acc.children << x }
    p a.descendants.map(&:data)

  end

  def teardown
  end

  # a << b
  # b << c
  # c << d

  # p d.parent
  # p a.descendants.map(&:data)
  # p d.ancestors.map(&:data)

  # c = Children.new
  # p c << TreeNode.new(:raju)
end
