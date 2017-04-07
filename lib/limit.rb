require_relative 'base'

class Limit < Base
  attr_accessor :type, :type_id, :limit, :views, :obj, :ad_id

  def initialize(obj, value)
    @views   = 0
    @obj     = obj
    @type    = obj.class
    @type_id = obj.id
    @limit   = value
  end

  def self.find_by(obj)
    self.rows.select {|x| x.type == obj.class and x.type_id == obj.id }
  end

  def inc_view
    @views = @views + 1
  end

  def exhausted?
    if self.limit.nil?
      false
    else
      self.views >= self.limit
    end
  end

  def type_instance
    self.type.find(type_id)
  end

end
