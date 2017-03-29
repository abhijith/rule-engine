class Limit
  attr_accessor :advert_id, :ltype, :ltype_id, :limit, :views

  @@coll    = []
  @@counter = 0

  def initialize(advert_id: nil, ltype_id: nil, ltype: nil)
    @views = 0
  end

  def self.count
    @@counter
  end

  def save
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

  def self.destroy_all
    @@coll    = []
    @@counter = 0
  end

  def exhausted?
    if self.limit.nil?
      false
    else
      self.views >= self.limit
    end
  end

end
