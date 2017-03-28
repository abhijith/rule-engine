class AdvertCountry
  attr_accessor :advert_id, :country_id, :label, :limit

  @@coll    = []
  @@counter = 0

  def initialize(label: nil)
    @label = label
  end

  def self.count
    @@counter
  end

  def save
    @@coll << self
    @@counter = @@counter + 1
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

end
