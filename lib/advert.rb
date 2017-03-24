class Advert

  attr_accessor :name, :start_date, :end_date, :category, :country, :language

  @@coll = []

  def initialize(cat: nil)
    @category = cat
  end

  def to_s
  end

  def save
    @@coll << self
  end

  def self.all
    @@coll
  end

  def self.find
    @@coll.find {|x| }
  end

  def self.destroy_all
    @@coll = []
  end

end
