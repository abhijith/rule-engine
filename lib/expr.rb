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
    p [lhs, rhs, op]
    lhs.send(op, rhs)
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
          rules: self.rules.map {|rule| rule.to_h }
          cond: self.cond
      }
    }
  end

  def run(ch, ad)
    p self.to_h
    gets
    vals = self.rules.map do |rule|
      rule.run(ch, ad)
    end
    vals.send(self.cond)
  end

end
