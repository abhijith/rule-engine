require_relative 'initializer'

class Expr
  attr_accessor :field, :type, :operator, :value

  FieldToType = {
    categories:  Category,
    preferences: Category,
    country:     Country,
    channel:     Channel
  }

  def initialize(field: nil, operator: nil, value: nil)
    @field    = field
    @operator = operator
    @value    = value

    if FieldToType.has_key?(field)
      @type = FieldToType[field]
    else
      raise InvalidField.new "Invalid field #{field} in rule: #{self.to_h}"
    end
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

  def satisfied?(request, debug = false)
    request_val = request.send(field)

    if value.is_a? Array
      value.each do |v|
        raise ProtocolError.new "#{type} in rule does not implement :find_by: #{self.to_h}" if not type.respond_to?(:find_by)
      end

      rule_val = value.map do |v|
        type.find_by(label: v)
      end
    else
      raise ProtocolError.new "#{type} in rule does not implement :find_by: #{self.to_h}" if not type.respond_to?(:find_by)
      rule_val = type.find_by(label: value)
    end

    raise InvalidOperator.new "Invalid operator #{operator} for #{rule_val.class}: #{self.to_h}" if not rule_val.respond_to?(operator)
    RpmLogger.debug({ rule_val: rule_val, operator: operator, request_val: request_val })

    rule_val.send(operator, request_val)
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

  def satisfied?(request, debug = false)
    res  = self.exprs.map {|rule| { expr: rule.to_h, val: rule.satisfied?(request, debug) } }
    vals = res.map {|x| x[:val] }
    RpmLogger.info(res)

    vals.send(self.cond)
  end

end
