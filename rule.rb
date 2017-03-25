require 'set'
require 'pp'
require_relative 'lib/expr'
require_relative 'lib/channel'
require_relative 'lib/advert'
require_relative 'lib/tree'

expr1 = Expr.new(ch: :pref, ad: :category, op: :intersect?)
expr2 = Expr.new(ch: :category, ad: :category, op: :==)
expr3 = Expr.new(ch: :category, ad: :category, op: :subtype?)
expr4 = ExprGroup.new(:all?, [expr2, expr3])

expr  = ExprGroup.new(:all?, [expr1, expr4])

a1 = Advert.new(cat: ["cars"])
a1.save
a2 = Advert.new(cat: ["gadgets"])
a2.save

c1 = Channel.new(cat: ["cars"], preference: ["cars", "gadgets"])
c2 = Channel.new(cat: ["food"], preference: ["food"])

class Array

  def subset(b)
    Set.new(self).subset?(Set.new(b))
  end

  def intersect?(b)
    Set.new(self).intersect?(Set.new(b))
  end

  def subtype?(b)
    b.is_a? self.class
  end

end

# [c1, c2].each do |c|
#   Advert.all.each do |a|
#     puts "-" * 10
#     puts expr.run(c, a)
#     puts "-" * 10
#   end
# end

# pp expr.to_h

a = TreeNode.new(:a)
b = TreeNode.new(:b)
c = TreeNode.new(:c)
d = TreeNode.new(:d)

a << b
b << c
c << d

p d.parent
p a.descendants.map(&:data)
p d.ancestors.map(&:data)
