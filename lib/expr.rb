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

  # TODO: make use of type information to dispatch the operator on the type instead of operating on id
  def satisfies?(request, debug = false)
    case type
    when :channel
      request_val = request.send(field)
      ch = Channel.find(value)
      ch.send(operator, request_val)
    when :country
      request_val = request.send(field)
      ch = Country.find(value)
      ch.send(operator, request_val)
    when :category
      request_val = request.send(field)
      if value.is_a? Array
        rule_val = value.map {|v| Category.find(v) }
      else
        rule_val = Category.find(value)
      end
      request_val.send(operator, rule_val)
    else
      false
    end
  end

end

class ExprGroup
  attr_accessor :cond, :exprs

  def initialize(c, r = [])
    @cond  = c
    @exprs = r
  end

  def self.load(file)
    self.parse(JSON.parse(File.read(file), symbolize_names: true))
  end

  # check if option is available in JSON.parse to provide custom `read` method
  def self.parse(h)
    if h.has_key?(:exprgroup)
      e = ExprGroup.new(h[:exprgroup][:cond], [])
      e.exprs = h[:exprgroup][:exprs].map {|x| self.parse(x) }
      e
    else
      Expr.new(field:    h[:expr][:field],
               type:     h[:expr][:type],
               operator: h[:expr][:operator],
               value:    h[:expr][:value])
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
