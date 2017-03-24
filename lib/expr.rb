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

  def to_sexp
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
      cond:  cond,
      rules: rules,
    }
  end

  def to_sexp
  end

end
