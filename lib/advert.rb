class Advert

  attr_accessor :name, :start_date, :end_date, :category, :country, :language, :views

  @@coll = []
  @@counter = 0

  def initialize(cat: nil)
    @category = cat
  end

  def self.load(file)
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
