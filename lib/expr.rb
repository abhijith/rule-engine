class Expr
  attr_accessor :channel, :advert, :operator

  def initialize(ch: nil, ad: nil, op: nil)
    @channel  = ch
    @advert   = ad
    @operator = op
  end

  def to_h
    {
      channel: channel,
      advert:  advert,
      operator: operator
    }
  end

  def run(ch, ad)
    lhs = ch.send(self.channel)
    rhs = ad.send(self.advert)
    op  = self.operator
    val = lhs.send(op, rhs)
    p [lhs, rhs, op, val]
    val
  end

end

class ExprGroup
  attr_accessor :cond, :rules

  def initialize(c, r)
    @cond  = c
    @rules = r
  end

  def to_h
    {
      group: {
          rules: self.rules.map {|rule| rule.to_h },
          cond: self.cond
      }
    }
  end

  def run(ch, ad)
    # pp self.to_h
    vals = self.rules.map {|rule| rule.run(ch, ad) }
    vals.send(self.cond)
  end

end