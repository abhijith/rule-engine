class Limit
  attr_accessor :id, :type, :type_id, :limit, :views, :obj, :ad_id

  @@coll    = []
  @@counter = 0

  def initialize(obj, value)
    @views   = 0
    @obj     = obj
    @type    = obj.class
    @type_id = obj.id
    @limit   = value
  end

  def self.count
    @@counter
  end

  def save
    self.id = @@counter
    @@coll << self
    @@counter = @@counter + 1
    self
  end

  def self.all
    @@coll
  end

  def self.find(id)
    @@coll[id]
  end

  def self.find_by(obj)
    @@coll.select {|x| x.type == obj.class and x.type_id == obj.id }
  end

  def self.destroy_all
    @@coll    = []
    @@counter = 0
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
