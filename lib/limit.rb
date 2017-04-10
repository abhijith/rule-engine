require_relative 'base'

class Limit < Base
  include Limited

  attr_accessor :type, :type_id, :obj, :ad_id

  def initialize(obj, value)
    @views   = 0
    @obj     = obj
    @type    = obj.class
    @type_id = obj.id
    @limit   = value
  end

  def to_h
    {
      limit: limit,
      views: views,
      obj: type_instance.to_h,
    }
  end

  def self.find_by(obj)
    super(type: obj.class, type_id: obj.id)
  end

  def type_instance
    self.type.find(type_id)
  end

end
