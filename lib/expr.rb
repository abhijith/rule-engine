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

    raise InvalidField.new, "Request field not found: #{field}" if not request.respond_to?(field)

    request_val = request.send(field)

    # fmap instead of if-else?
    if value.is_a? Array
      value.each do |v|
        raise InvalidType.new, "Invalid type #{type} in rule: #{self.to_h}" if not type.respond_to?(:find)
      end

      rule_val = value.map do |v|
        type.send(:find, v)
      end
    else
      raise InvalidType.new, "Invalid type #{type} in rule: #{self.to_h}" if not type.respond_to?(:find)
      rule_val = type.send(:find, value)
    end

    raise InvalidOperator.new, "Invalid operator #{operator} for #{request_val.class}" if not request_val.respond_to?(operator)
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
        cond:  self.cond
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
