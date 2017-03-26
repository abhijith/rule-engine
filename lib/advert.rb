class Advert

  attr_accessor :name, :start_date, :end_date, :category, :language, :views

  @@coll = []
  @@counter = 0

  def initialize(category: nil, language: nil)
    @category = category
  end

  def self.load(coll)
    coll.map {|h| Advert.new(h).save }
  end

  def to_s
  end

  def self.count
    @@counter
  end

  def save
    @@counter = @@counter + 1
    @@coll << self
  end

  def self.all
    @@coll
  end

  def self.find(id)
    @@coll[id]
  end

  def self.destroy_all
    @@coll = []
  end

end
