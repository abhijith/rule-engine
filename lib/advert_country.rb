class AdvertCountry
  attr_accessor :advert_id, :country_id, :view_limit, :views

  @@coll    = []
  @@counter = 0

  def initialize(advert_id: nil, channel_id: nil)
    @views = 0
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
