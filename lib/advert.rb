class Advert

  attr_accessor :name, :start_date, :end_date, :country, :language, :limit

  @@coll    = []
  @@counter = 0

  def initialize
  end

  def self.load(file)
    JSON.parse(File.read(file), symbolize_names: true)
  end

  def self.parse(coll)
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
