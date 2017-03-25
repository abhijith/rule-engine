require 'set'
require_relative 'lib/expr'
require_relative 'lib/channel'
require_relative 'lib/advert'

expr1 = Expr.new(ch: :pref, ad: :category, op: :intersect?)
expr2 = Expr.new(ch: :category, ad: :category, op: :==)
expr3 = Expr.new(ch: :category, ad: :category, op: :subtype?)

nested_rule = ExprGroup.new(:and, [expr1, ExprGroup.new(:or, [expr2, expr3])])
flat_rule = ExprGroup.new(:or, [expr1, expr2, expr3])

a1 = Advert.new(cat: ["cars"])
a1.save
a2 = Advert.new(cat: ["gadgets"])
a2.save

p Advert.all

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

def run(expr, channel, advert)
  lhs = channel.send(expr.channel)
  rhs = advert.send(expr.advert)
  op  = expr.operator
  p [lhs, rhs, op]
  lhs.send(op, rhs)
end

p run(expr1, r1, a1)
p run(expr2, r1, a1)
p run(expr3, r1, a1)
p run(expr1, r1, a2)
p run(expr2, r1, a2)
p run(expr3, r1, a2)

p run(expr1, r2, a1)
p run(expr2, r2, a1)
p run(expr3, r2, a1)
p run(expr1, r2, a2)
p run(expr2, r2, a2)
p run(expr3, r2, a2)
