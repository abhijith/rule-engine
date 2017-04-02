require_relative 'utils'

class Expr
  attr_accessor :field, :type, :operator, :value

  def initialize(field: nil, type: nil, operator: nil, value: nil)
    @field    = field
    @type     = type
    @operator = operator
    @value    = value
  end

  def to_h
    {
      expr: {
        :field    => field,
        :type     => type,
        :operator => operator,
        :value    => value
      }
    }
  end

  def satisfies?(request, debug = false)
    if debug
      pp self.to_h
      pp request
    end
    request_val = request.send(field)
    if value.is_a? Array
      rule_val = value.map {|v| type.send(:find, v) }
    else
      rule_val = type.send(:find, value)
    end
    request_val.send(operator, rule_val)
  end

end

class ExprGroup
  attr_accessor :cond, :exprs

  def initialize(c, r = [])
    @cond  = c
    @exprs = r
  end

  def to_h
    {
      exprgroup: {
        exprs: self.exprs.map {|rule| rule.to_h },
        cond: self.cond
      }
    }
  end

  def satisfies?(request, debug = false)
    res  = self.exprs.map {|rule| { expr: rule.to_h, val: rule.satisfies?(request, debug) } }
    vals = res.map {|x| x[:val] }
    if debug
      pp res
      pp vals
    end
    vals.send(self.cond)
  end

end
