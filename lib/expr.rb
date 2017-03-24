class Expr
  attr_accessor :channel, :advert, :operator

  def initialize(channel: nil, advert: nil, operator: nil)
    @channel  = channel
    @advert   = advert
    @operator = operator
  end
end
