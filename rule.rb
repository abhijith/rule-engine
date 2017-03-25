require 'set'
require_relative 'lib/expr'
require_relative 'lib/channel'
require_relative 'lib/advert'

expr1 = Expr.new(ch: :pref, ad: :category, op: :intersect?)
expr2 = Expr.new(ch: :category, ad: :category, op: :==)
expr3 = Expr.new(ch: :category, ad: :category, op: :subtype?)

nested_rule = ExprGroup.new(:all?, [expr1, ExprGroup.new(:any?, [expr2, expr3])])
flat_rule   = ExprGroup.new(:any?, [expr1, expr2, expr3])

a1 = Advert.new(cat: ["cars"])
a1.save
a2 = Advert.new(cat: ["gadgets"])
a2.save

r1 = Channel.new(cat: ["cars"], preference: ["cars", "gadgets"])
r2 = Channel.new(cat: ["cars"], preference: ["gadgets"])

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

p nested_rule.run(r1, a1)
