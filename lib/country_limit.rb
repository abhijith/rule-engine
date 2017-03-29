class CountryLimit
  attr_accessor :advert_id, :country_id, :limit, :views

  @@coll    = []
  @@counter = 0

  def initialize(advert_id: nil, country_id: nil, limit: nil)
    @views      = 0
    @limit      = limit
    @advert_id  = advert_id
    @country_id = country_id
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

  def inc_view
    @views = @views.succ
  end

  def exhausted?
    if self.limit.nil?
      false
    else
      self.views >= self.limit
    end
  end

  def advert
    Advert.find(self.advert_id)
  end

  def country
    Country.find(self.country_id)
  end

end
