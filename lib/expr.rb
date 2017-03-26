require_relative 'utils'

class Expr
  attr_accessor :channel, :advert, :operator

  def initialize(ch: nil, ad: nil, op: nil)
    @channel  = ch
    @advert   = ad
    @operator = op
  end

  def to_h
    {
      expr: {
        channel:  channel,
        advert:   advert,
        operator: operator
      }
    }
  end

  def run(ch, ad, debug = false)
    lhs = ch.send(self.channel)
    rhs = ad.send(self.advert)
    op  = self.operator
    val = lhs.send(op, rhs)
    p [lhs, rhs, op, val] # if debug
    val
  end

end

class ExprGroup
  attr_accessor :cond, :exprs

  def initialize(c, r = [])
    @cond  = c
    @exprs = r
  end

  # check if option is available in JSON.parse to provide custom `read` method
  def self.load(h)
    if h.has_key?(:exprgroup)
      e = ExprGroup.new(h[:exprgroup][:cond], [])
      e.exprs = h[:exprgroup][:exprs].map {|x| self.load(x) }
      e
    else
      Expr.new(ch: h[:expr][:channel], ad: h[:expr][:advert], op: h[:expr][:operator])
    end
  end

  def to_h
    {
      exprgroup: {
        exprs: self.exprs.map {|rule| rule.to_h },
        cond: self.cond
      }
    }
  end

  def run(ch, ad, debug = false)
    vals = self.exprs.map {|rule| rule.run(ch, ad, debug) }
    vals.send(self.cond)
  end

end
